//
//  MyObject.m
//  Test
//
//  Created by wesley_chen on 2019/6/17.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import "MyObject.h"

@implementation MyObject

- (void)dealloc {
    NSLog(@"%p retain count: %d", self, (int)CFGetRetainCount((__bridge CFTypeRef)self));
}

@end
