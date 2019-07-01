//
//  BaseClassA1.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "BaseClassA1.h"

@implementation BaseClassA1

- (NSString *)thisMethodOverrideByCategory {
    NSLog(@"BaseClassA1: thisMethodOverrideByCategory called");
    
    return @"BaseClassA1->thisMethodOverrideByCategory";
}

- (NSString *)internallyCallThisMethodOverrideByCategory {
    // Note: example from https://stackoverflow.com/a/14259595
    return [self thisMethodOverrideByCategory];
}

@end
