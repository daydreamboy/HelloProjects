//
//  MyCycle_twoMoreInitMethod.m
//  Tests
//
//  Created by wesley_chen on 2020/3/6.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "MyCycle_twoMoreInitMethod.h"

@implementation MyCycle_twoMoreInitMethod

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

- (instancetype)initRadius:(JSValue *)radius {
    self = [super init];
    if (self) {
        _radius = [radius toDouble];
        _diameter = 0;
    }
    return self;
}

- (instancetype)initWithDiameter:(CGFloat)diameter {
    self = [super init];
    if (self) {
        _radius = 0;
        _diameter = diameter;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"radius: %f, diameter: %f", self.radius, self.diameter];
}

@end
