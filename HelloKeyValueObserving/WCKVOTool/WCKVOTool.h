//
//  WCKVOTool.h
//  HelloKeyValueObserving
//
//  Created by wesley_chen on 2018/9/25.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCKVORegistrationInfo : NSObject
@property (nonatomic, weak, nullable) NSObject *observedObject;
@property (nonatomic, weak, nullable) NSObject *observer;
@property (nonatomic, copy) NSString *keyPath;
@property (nonatomic, assign) NSKeyValueObservingOptions options;
@property (nonatomic, assign, nullable) void *context;
@end

@interface WCKVOTool : NSObject
/// the registration info which stores the pair object -> WCKVORegistrationInfo
@property (nonatomic, strong, readonly, nullable) NSMapTable *registrationInfos;

#pragma mark - Safe to wrap KVO

- (BOOL)addObserverWithObject:(NSObject *)object observer:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
- (BOOL)removeObserverWithObject:(NSObject *)object observer:(NSObject *)observer forKeyPath:(NSString *)keyPath context:(nullable void *)context;
- (BOOL)removeObserverWithObject:(NSObject *)object observer:(NSObject *)observer forKeyPath:(NSString *)keyPath;

#pragma mark - Get KVO Info

/**
 Get observers from an object's observationInfo
 
 @param observationInfo the NSObject's property `observationInfo`
 @return the pointer array which weakly hold objects. Return nil if there's no observer or some internal errors happened.
 @see https://stackoverflow.com/a/9322342
 */
+ (nullable NSPointerArray *)observersWithObservationInfo:(void *)observationInfo;

@end

NS_ASSUME_NONNULL_END
