//
//  WCKVOTool.m
//  HelloKeyValueObserving
//
//  Created by wesley_chen on 2018/9/25.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "WCKVOTool.h"

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
