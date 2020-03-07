//
//  MyCycle.m
//  Tests
//
//  Created by wesley_chen on 2020/3/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "MyCycle.h"

@implementation MyCycle

@synthesize radius = _radius;
@synthesize diameter = _diameter;
@synthesize x = _x;
@synthesize y = _y;

- (instancetype)initWithRadius:(JSValue *)radius x:(JSValue *)x y:(JSValue *)y {
    self = [super init];
    if (self) {
        _radius = radius.isUndefined ? 0 : [radius toDouble];
        _x = x.isUndefined ? 0 : [x toDouble];
        _y = y.isUndefined ? 0 : [y toDouble];
    }
    return self;
}

- (CGFloat)diameter {
    return _radius * 2.0;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"radius: %f, x: %f, y: %f", self.radius, self.x, self.y];
}

@end
