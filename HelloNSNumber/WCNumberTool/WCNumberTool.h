//
//  WCNumberTool.h
//  HelloNSNumber
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCNumberTool : NSObject

/**
 Get factorial of a number

 @param number the nunmber
 @return the factorial value
 @see http://nshipster.cn/nsexpression/
 */
+ (nullable NSNumber *)factorialWithNumber:(NSNumber *)number;

/**
 Check a number if wrap a boolean

 @param number the number
 @return YES if the number wraps a boolean, NO if not
 @see https://stackoverflow.com/a/30223989
 */
+ (BOOL)checkNumberAsBooleanWithNumber:(NSNumber *)number;

@end

NS_ASSUME_NONNULL_END
