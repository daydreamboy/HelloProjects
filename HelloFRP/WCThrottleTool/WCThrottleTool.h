//
//  WCThrottleTool.h
//  HelloFRP
//
//  Created by wesley_chen on 2021/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCThrottleTool : NSObject

+ (BOOL)checkTimestampOutdateWithUniqueKey:(NSString *)uniqueKey forBizKey:(NSString *)bizKey timeGap:(NSTimeInterval)timeGap;

+ (BOOL)markTimestampWithUniqueKey:(NSString *)uniqueKey forBizKey:(NSString *)bizKey;

+ (BOOL)clearTimestampWithUniqueKey:(NSString *)uniqueKey forBizKey:(NSString *)bizKey;

+ (BOOL)clearAllTimestampsForBizKey:(NSString *)bizKey;

+ (BOOL)clearAllTimestamps;

@end

NS_ASSUME_NONNULL_END
