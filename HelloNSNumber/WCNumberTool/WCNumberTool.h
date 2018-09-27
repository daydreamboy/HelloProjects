//
//  WCNumberTool.h
//  HelloNSNumber
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCNumberTool : NSObject

/**
 Get factorial of a number

 @param number the nunmber
 @return the factorial value
 @see http://nshipster.cn/nsexpression/
 */
+ (NSNumber *)factorialWithNumber:(NSNumber *)number;

@end
