//
//  MyCycle_noInitMethod.m
//  Tests
//
//  Created by wesley_chen on 2020/3/6.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "MyCycle_noInitMethod.h"

@implementation MyCycle_noInitMethod

@synthesize radius = _radius;
@synthesize diameter = _diameter;

- (instancetype)init {
    self = [super init];
    if (self) {
        _radius = 0;
        _diameter = 0;
    }
    return self;
}

@end
