//
//  WCDelegateProxy.m
//  HelloNSProxy
//
//  Created by wesley_chen on 2018/5/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDelegateProxy.h"
#import <libkern/OSAtomic.h>

static CFMutableDictionaryRef sProtocolCache = nil;
static OSSpinLock sLock = OS_SPINLOCK_INIT;

@implementation WCDelegateProxy {
    CFDictionaryRef _signatures;
}

#pragma mark - Public Methods

- (instancetype)initWithDelegate:(id)delegate conformingToProtocol:(Protocol *)protocol defaultReturnValue:(NSValue *)returnValue {
    NSParameterAssert(protocol);
    NSParameterAssert(returnValue == nil || [returnValue isKindOfClass:[NSValue class]]);
    if (self) {
        _delegate = delegate;
        _protocol = protocol;
        _defaultReturnValue = returnValue;
    }
    
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p delegate:%@ protocol:%@>", self.class, self, self.delegate, self.protocol];
}

- (instancetype)copyThatDefaultsTo:(NSValue *)defaultValue {
    return [[self.class alloc] initWithDelegate:_delegate conformingToProtocol:_protocol defaultReturnValue:defaultValue];
}

- (instancetype)copyThatDefaultsToYES {
    return [self copyThatDefaultsTo:@YES];
}

#pragma mark -

- (BOOL)respondsToSelector:(SEL)selector {
    return [_delegate respondsToSelector:selector];
}

- (id)forwardingTargetForSelector:(SEL)selector {
    id delegate = _delegate;
    // Note: 判断_delegate是否响应selector，不响应则WCDelegateProxy处理
    return [delegate respondsToSelector:selector] ? delegate : self;
}

// Note: regular message forwarding continues if delegate doesn't respond to selector or is nil.
- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    // Note: 检查_delegate是否有selector对应的方法签名
    NSMethodSignature *signature = [_delegate methodSignatureForSelector:selector];
    if (!signature) {
        // Note: 从运行时根据_protocol查找selector对应的方法签名，
        if (!_signatures) _signatures = [self methodSignaturesForProtocol:_protocol];
        signature = CFDictionaryGetValue(_signatures, selector);
    }
    
    // Note: 必须返回非nil的方法签名，否则产生crash，*** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '*** -[NSProxy doesNotRecognizeSelector:<seletor>] called!
    // 不实现该方法，NSProxy默认也会产生异常
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    // Set a default return type if set.
    if (_defaultReturnValue && strcmp(_defaultReturnValue.objCType, invocation.methodSignature.methodReturnType) == 0) {
        char buffer[invocation.methodSignature.methodReturnLength];
        [_defaultReturnValue getValue:buffer];
        [invocation setReturnValue:&buffer];
    }
}

- (CFDictionaryRef)methodSignaturesForProtocol:(Protocol *)protocol {
    OSSpinLockLock(&sLock);
    // Cache lookup
    if (!sProtocolCache) sProtocolCache = CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
    CFDictionaryRef signatureCache = CFDictionaryGetValue(sProtocolCache, (__bridge const void *)(protocol));
    
    if (!signatureCache) {
        // Add protocol methods + derived protocol method definitions into protocolCache.
        signatureCache = CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
        [self methodSignaturesForProtocol:protocol inDictionary:(CFMutableDictionaryRef)signatureCache];
        CFDictionarySetValue(sProtocolCache, (__bridge const void *)(protocol), signatureCache);
        CFRelease(signatureCache);
    }
    OSSpinLockUnlock(&sLock);
    return signatureCache;
}

- (void)methodSignaturesForProtocol:(Protocol *)protocol inDictionary:(CFMutableDictionaryRef)cache {
    void (^enumerateRequiredMethods)(BOOL) = ^(BOOL isRequired) {
        unsigned int methodCount;
        struct objc_method_description *descr = protocol_copyMethodDescriptionList(protocol, isRequired, YES, &methodCount);
        for (NSUInteger idx = 0; idx < methodCount; idx++) {
            NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:descr[idx].types];
            CFDictionarySetValue(cache, descr[idx].name, (__bridge const void *)(signature));
        }
        free(descr);
    };
    // We need to enumerate both required and optional protocol methods.
    enumerateRequiredMethods(NO);
    enumerateRequiredMethods(YES);
    
    // There might be sub-protocols we need to catch as well.
    unsigned int inheritedProtocolCount;
    Protocol *__unsafe_unretained* inheritedProtocols = protocol_copyProtocolList(protocol, &inheritedProtocolCount);
    for (NSUInteger idx = 0; idx < inheritedProtocolCount; idx++) {
        [self methodSignaturesForProtocol:inheritedProtocols[idx] inDictionary:cache];
    }
    free(inheritedProtocols);
}

@end
