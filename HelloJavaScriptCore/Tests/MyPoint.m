//
//  MyPoint.m
//  Tests
//
//  Created by wesley_chen on 2019/2/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint

- (NSString *)description {
    return [NSString stringWithFormat:@"<MyPoint: %p, x: %f, y: %f>", self, self.x, self.y];
}

- (instancetype)initWithX:(double)x y:(double)y {
    self = [super init];
    if (self) {
        _x = x;
        _y = y;
    }
    return self;
}

+ (MyPoint *)makePointWithX:(double)x y:(double)y {
    return [[self alloc] initWithX:x y:y];
}

+ (MyPoint *)makePoint2WithX:(double)x y:(double)y {
    return [[self alloc] initWithX:x y:y];
}

- (void)myPrivateMethod {
    NSLog(@"myPrivateMethod");
}

@end
