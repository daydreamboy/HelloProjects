//
//  BaseClassA1+Category.m
//  Tests_OC
//
//  Created by wesley_chen on 2019/6/29.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "BaseClassA1+Category.h"

@implementation BaseClassA1 (Category)

- (NSString *)thisMethodOverrideByCategory {
    NSLog(@"BaseClassA1 (Category): thisMethodOverrideByCategory called");
    
    return @"BaseClassA1 (Category)->thisMethodOverrideByCategory";
}

@end
