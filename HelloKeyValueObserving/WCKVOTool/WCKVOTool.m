//
//  WCKVOTool.m
//  HelloKeyValueObserving
//
//  Created by wesley_chen on 2018/9/25.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "WCKVOTool.h"
#import <objc/runtime.h>

@interface WCKVOObserver ()
@property (nonatomic, weak, readwrite) id observedObject;
@property (nonatomic, copy, readwrite) WCKVOObserverEventCallback eventCallback;
@property (nonatomic, copy, readwrite) NSString *keyPath;
@property (nonatomic, assign, readwrite) NSKeyValueObservingOptions options;
@end

@implementation WCKVOObserver

- (instancetype)initWithObservedObject:(id)observedObject keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options eventCallback:(WCKVOObserverEventCallback)eventCallback  {
    self = [super init];
    if (self) {
        _observedObject = observedObject;
        _keyPath = keyPath;
        _options = options;
        _eventCallback = eventCallback;
        
        [_observedObject addObserver:self forKeyPath:keyPath options:options context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (_observedObject == object && [keyPath isEqualToString:_keyPath]) {
        !_eventCallback ?: _eventCallback(_observedObject, self, change, context);
    }
}

- (void)dealloc {
    @try {
        [_observedObject removeObserver:self forKeyPath:_keyPath];
    }
    @catch (NSException *exception) {
#if DEBUG
        NSLog(@"an exception occurred: %@", exception);
#endif
    }
}

@end

@implementation WCKVORegistrationInfo
@end

@interface WCKVOTool ()
@property (nonatomic, strong, readwrite, nullable) NSMapTable *registrationInfos;
@end

@implementation WCKVOTool

#pragma mark - Safe to wrap KVO

- (BOOL)addObserverWithObject:(NSObject *)object observer:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    if (![object isKindOfClass:[NSObject class]] || ![observer isKindOfClass:[NSObject class]] || ![keyPath isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    BOOL success = YES;
    
    NSString *key = [NSString stringWithFormat:@"%p_%p_%@", object, observer, keyPath];
    
    WCKVORegistrationInfo *registrationInfo = [self.registrationInfos objectForKey:key];
    if (!registrationInfo) {
        WCKVORegistrationInfo *info = [WCKVORegistrationInfo new];
        info.observedObject = object;
        info.observer = observer;
        info.keyPath = keyPath;
        info.options = options;
        info.context = context;
        
        [self.registrationInfos setObject:info forKey:key];
        
        [object addObserver:observer forKeyPath:keyPath options:options context:context];
    }
    else {
        success = NO;
    }
    
    return success;
}

- (BOOL)removeObserverWithObject:(NSObject *)object observer:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context {
    if (![object isKindOfClass:[NSObject class]] || ![observer isKindOfClass:[NSObject class]] || ![keyPath isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    BOOL success = YES;
    
    NSString *key = [NSString stringWithFormat:@"%p_%p_%@", object, observer, keyPath];
    WCKVORegistrationInfo *registrationInfo = [self.registrationInfos objectForKey:key];
    if (registrationInfo) {
        @try {
            [object removeObserver:observer forKeyPath:keyPath context:context];
        }
        @catch (NSException *exception) {
            success = NO;
            NSLog(@"%@", exception);
        }
        @finally {
            [self.registrationInfos removeObjectForKey:key];
        }
    }
    else {
        success = NO;
    }
    
    return success;
}

- (BOOL)removeObserverWithObject:(NSObject *)object observer:(NSObject *)observer forKeyPath:(NSString *)keyPath {
    if (![object isKindOfClass:[NSObject class]] || ![observer isKindOfClass:[NSObject class]] || ![keyPath isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    BOOL success = YES;
    
    NSString *key = [NSString stringWithFormat:@"%p_%p_%@", object, observer, keyPath];
    WCKVORegistrationInfo *registrationInfo = [self.registrationInfos objectForKey:key];
    if (registrationInfo) {
        @try {
            [object removeObserver:observer forKeyPath:keyPath];
        }
        @catch (NSException *exception) {
            success = NO;
            NSLog(@"%@", exception);
        }
        @finally {
            [self.registrationInfos removeObjectForKey:key];
        }
    }
    else {
        success = NO;
    }
    
    return success;
}

#pragma mark - Get KVO Info

+ (nullable NSPointerArray *)observersWithObservationInfo:(void *)observationInfo {
    id observationInfoObject = (__bridge id)(observationInfo);
    if (![observationInfoObject isKindOfClass:NSClassFromString(@"NSKeyValueObservationInfo")]) {
        return nil;
    }
    
    NSArray *observances = [self safeValueWithObject:observationInfoObject forKey:@"observances" typeClass:[NSArray class]];
    if (!observances) {
        return nil;
    }
    
    NSPointerArray *pointers = [NSPointerArray weakObjectsPointerArray];
    for (NSInteger i = 0; i < observances.count; i++) {
        id element = observances[i];
        if ([element isKindOfClass:NSClassFromString(@"NSKeyValueObservance")]) {
            id observer = [self safeValueWithObject:element forKey:@"observer" typeClass:[NSObject class]];
            if (observer) {
                [pointers addPointer:(__bridge void * _Nullable)(observer)];
            }
        }
    }
    
    NSPointerArray *pointerArray = nil;
    if (pointers.count) {
        pointerArray = pointers;
    }
    
    return pointerArray;
}

#pragma mark - Auto KVO

+ (BOOL)observeKVOEventWithObject:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options associatedKey:(const void *)associatedKey eventCallback:(WCKVOObserverEventCallback)eventCallback {
    if (![object isKindOfClass:[NSObject class]] || eventCallback == nil) {
        return NO;
    }
    
    id associatedObject = objc_getAssociatedObject(object, associatedKey);
    if (associatedObject) {
        return NO;
    }
    
    WCKVOObserver *observer = [[WCKVOObserver alloc] initWithObservedObject:object keyPath:keyPath options:options eventCallback:eventCallback];
    objc_setAssociatedObject(object, associatedKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return YES;
}

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        _registrationInfos = [NSMapTable strongToStrongObjectsMapTable];
    }
    return self;
}

#pragma mark - Utility

+ (nullable id)safeValueWithObject:(NSObject *)object forKey:(NSString *)key typeClass:(Class)typeClass {
    if (![object isKindOfClass:[NSObject class]] || ![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    id returnValue = nil;
    @try {
        returnValue = [object valueForKey:key];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
    @finally {
        if ([returnValue isKindOfClass:typeClass]) {
            return returnValue;
        }
        else {
            return nil;
        }
    }
}
@end
