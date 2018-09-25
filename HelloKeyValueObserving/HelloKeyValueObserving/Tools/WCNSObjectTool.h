//
//  WCNSObjectTool.h
//  HelloKeyValueObserving
//
//  Created by wesley_chen on 2018/9/25.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCNSObjectTool : NSObject
@end

@interface WCNSObjectTool ()
#pragma mark - Safe KVC

/**
 Safe to get an instance with the specific class type by key
 
 @param object the instance of NSObject
 @param key the key
 @return return nil if the key not exists or object is not a NSObject
 @discussion This method is safe to wrap valueForKey: of KVC
 */
+ (nullable id)safeValueWithObject:(NSObject *)object forKey:(NSString *)key;

/**
 Safe to get an instance with the specific class type by key

 @param object the instance of NSObject
 @param key the key
 @param typeClass the expected class of the returned object
 @return return nil if the key not exists or object is not a NSObject
 @discussion This method is safe to wrap valueForKey: of KVC
 */
+ (nullable id)safeValueWithObject:(NSObject *)object forKey:(NSString *)key typeClass:(Class)typeClass;

@end

NS_ASSUME_NONNULL_END
