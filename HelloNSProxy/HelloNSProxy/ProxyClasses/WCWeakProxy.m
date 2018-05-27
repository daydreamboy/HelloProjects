//
//  WCWeakProxy.m
//  HelloNSProxy
//
//  Created by wesley_chen on 2018/5/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCWeakProxy.h"

@interface WCWeakProxy ()
@property (nonatomic, weak, readwrite) id target;
@end

@implementation WCWeakProxy

#pragma mark - Public Methods

- (instancetype)initWithTarget:(id)target {
    _target = target;
    return self;
}

+ (instancetype)proxyWithTarget:(id)target {
    return [[WCWeakProxy alloc] initWithTarget:target];
}

#pragma mark -

// Note: WCWeakProxy没有对应的方法，转发到对应的target对象上
- (id)forwardingTargetForSelector:(SEL)selector {
    return _target;
}

- (void)dealloc {
    // Note: here NSLog(@"%@", self) not correctly print its description, so use object_getClassName
    NSLog(@"<%s: %p> dealloc", object_getClassName(self), self);
}

#pragma mark - Override Methods

// Note: 如果WCWeakProxy没有释放，而_target是nil，则会forwardingTargetForSelector -> methodSignatureForSelector -> forwardInvocation
- (void)forwardInvocation:(NSInvocation *)invocation {
    void *null = NULL;
    [invocation setReturnValue:&null];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)sel {
    return [NSObject instanceMethodSignatureForSelector:@selector(init)];
}

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [_target respondsToSelector:aSelector];
}

- (NSString *)description {
    // @see https://www.mikeash.com/pyblog/friday-qa-2010-07-16-zeroing-weak-references-in-objective-c.html
    return [NSString stringWithFormat: @"<%@: %p -> %@>", [self class], self, _target];
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat: @"<%@: %p -> %@>", [self class], self, _target];
}

#pragma mark - NSObject

- (BOOL)isProxy {
    return YES;
}

- (BOOL)isKindOfClass:(Class)aClass {
    return [_target isKindOfClass:aClass];
}

- (BOOL)isMemberOfClass:(Class)aClass {
    return [_target isMemberOfClass:aClass];
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    return [_target conformsToProtocol:aProtocol];
}

- (BOOL)isEqual:(id)object {
    return [_target isEqual:object];
}

- (NSUInteger)hash {
    return [_target hash];
}

- (Class)superclass {
    return [_target superclass];
}

- (Class)class {
    return [_target class];
}

- (instancetype)self {
    return [_target self];
}

@end
