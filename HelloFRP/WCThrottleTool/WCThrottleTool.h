//
//  WCThrottleTool.h
//  HelloFRP
//
//  Created by wesley_chen on 2021/6/10.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A thread safe throttle tool to control the frequent tasks, such as networking request
 */
@interface WCThrottleTool : NSObject

/**
 Check the gap between current timestamp and marked timestamp if greater than the time gap
 
 @param uniqueKey the uniqueu key for identifying the marked timestamp
 @param bizKey the business key
 @param timeGap the constant time gap
 
 @return YES if the current timestamp - marked timestamp > timeGap, or return NO if not
 
 @note If timeGap is zero or negative, the return value is always YES
 */
+ (BOOL)checkTimestampOutdateWithUniqueKey:(NSString *)uniqueKey forBizKey:(NSString *)bizKey timeGap:(NSTimeInterval)timeGap;

/**
 Mark a timestamp using current time
 
 @param uniqueKey the uniqueu key for identifying the marked timestamp
 @param bizKey the business key
 
 @return YES if operate successfully, NO if the parameters are not correct
 
 @discussion call this method again will overwrite the previous marked timestamp
 */
+ (BOOL)markTimestampWithUniqueKey:(NSString *)uniqueKey forBizKey:(NSString *)bizKey;

/**
 Clear the marked timestamp
 
 @param uniqueKey the uniqueu key for identifying the marked timestamp
 @param bizKey the business key
 
 @return YES if operate successfully, NO if the parameters are not correct
 */
+ (BOOL)clearTimestampWithUniqueKey:(NSString *)uniqueKey forBizKey:(NSString *)bizKey;

/**
 Clear all marked timestamp under the specific bizKey
 
 @param bizKey the business key
 
 @return YES if operate successfully, NO if the parameters are not correct
 */
+ (BOOL)clearAllTimestampsForBizKey:(NSString *)bizKey;

/**
 Clear all marked timestamp
 
 @return YES if operate successfully, NO if the parameters are not correct
 */
+ (BOOL)clearAllTimestamps;

@end

NS_ASSUME_NONNULL_END
