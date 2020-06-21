//
//  WCKVOTool.h
//  HelloUIView
//
//  Created by wesley_chen on 2020/4/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCKVOObserver : NSObject
@property (nonatomic, weak, readonly) id observedObject;
@property (nonatomic, copy, readonly) void(^eventCallback)(id observedObject, WCKVOObserver *observer);
@property (nonatomic, copy, readonly) NSString *keyPath;
@property (nonatomic, assign, readonly) NSKeyValueObservingOptions options;
@end

@interface WCKVOTool : NSObject

@end

@interface WCKVOTool ()

+ (BOOL)observeKVOEventWithObject:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options associatedKey:(const void *)associatedKey eventCallback:(void (^)(id object, WCKVOObserver *observer))eventCallback;

@end

NS_ASSUME_NONNULL_END
