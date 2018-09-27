//
//  WCNumberTool.m
//  HelloNSNumber
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCNumberTool.h"

@implementation WCNumberTool

+ (NSNumber *)factorialWithNumber:(NSNumber *)number {
    return @(tgamma([number doubleValue] + 1));
}

@end
