//
//  WCXCTestCaseTool.m
//  Test
//
//  Created by wesley_chen on 2020/3/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCXCTestCaseTool.h"
#import <QuartzCore/QuartzCore.h>

@implementation WCXCTestCaseTool

+ (BOOL)timingMesaureAverageWithCount:(NSUInteger)count block:(void (^)(void))block {
    if (count == 0 || !block) {
        return NO;
    }
    
    NSTimeInterval startTime;
    NSTimeInterval endTime;
    
    startTime = CACurrentMediaTime();
    for (NSUInteger i = 0; i < count; ++i) {
        block();
    }
    endTime = CACurrentMediaTime();
    NSLog(@"average: %f, count: %ld", (endTime - startTime) / count, (long)count);
    
    return YES;
}

@end
