//
//  WCSharedContextManager.h
//  Tests
//
//  Created by wesley_chen on 2019/6/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCSharedContext.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A class manages the shared context
 */
@interface WCSharedContextManager : NSObject

/**
 The singelton

 @return the shared instance
 */
+ (instancetype)sharedInstance;

/**
 Get or create a shared context by key

 @param key the key expected to be NSString. If not NSString, return nil
 @return the shared context instance.
 */
- (nullable id<WCSharedContext>)objectForKeyedSubscript:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
