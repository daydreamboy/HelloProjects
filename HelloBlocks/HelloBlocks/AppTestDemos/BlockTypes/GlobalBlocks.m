//
//  GlobalBlocks.m
//  HelloBlocks
//
//  Created by wesley_chen on 2021/5/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "GlobalBlocks.h"

static int g_a = 0;
int g_b = 1;
const int g_c = 2;

@implementation GlobalBlocks
+ (id)block1 {
    // Note: __NSGlobalBlock__
    void (^globalBlock)(void) = ^{
        NSLog(@"This is a __NSGlobalBlock__");
    };
    return globalBlock;
}

+ (id)block2 {
    void (^globalBlock)(void) = ^{
        // Note: __NSGlobalBlock__
        int sum = g_a + g_b + 1;
        NSLog(@"sum is %d", sum);
    };
    return globalBlock;
}

+ (id)block3 {
    // Note: __NSGlobalBlock__
    void (^globalBlock)(void) = ^{
        int a = 1;
        int b = 2;
        int sum = a + b + g_c;
        NSLog(@"sum is %d", sum);
    };
    return globalBlock;
}

+ (id)block4 {
    // Note: __NSGlobalBlock__
    void (^mallocBlock)(int) = ^(int a) {
        // Note: __NSGlobalBlock__
        int sum = a + g_b + 1;
        NSLog(@"sum is %d", sum);
    };
    
    mallocBlock(1);
    
    return mallocBlock;
}

+ (id)block5 {
    // Note: __NSGlobalBlock__
    void (^globalBlock)(void) = ^{
        NSLog(@"This is a __NSGlobalBlock__");
    };
    // Note: __NSGlobalBlock__
    id alsoGlobalBlock = [globalBlock copy];
    return alsoGlobalBlock;
}

@end
