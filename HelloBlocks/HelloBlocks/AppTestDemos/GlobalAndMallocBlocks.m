//
//  GlobalAndMallocBlocks.m
//  HelloBlocks
//
//  Created by wesley_chen on 27/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GlobalAndMallocBlocks.h"

static int a = 0;
int b = 1;
const int c = 2;

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
        int sum = a + b + 1;
        NSLog(@"sum is %d", sum);
    };
    return globalBlock;
}

+ (id)block3 {
    // Note: __NSGlobalBlock__
    void (^globalBlock)(void) = ^{
        int a = 1;
        int b = 2;
        int sum = a + b + c;
        NSLog(@"sum is %d", sum);
    };
    return globalBlock;
}

+ (id)block4 {
    // Note: __NSGlobalBlock__
    void (^mallocBlock)(int) = ^(int a) {
        // Note: __NSGlobalBlock__
        int sum = a + b + 1;
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

@implementation MallocBlocks

+ (id)block1 {
    int a = 1;
    void (^mallocBlock)(void) = ^{
        // Note: __NSMallocBlock__
        int sum = a + b + 1;
        NSLog(@"sum is %d", sum);
    };
    return mallocBlock;
}

+ (id)block2 {
    void (^mallocBlock)(void) = ^{
        // Note: __NSMallocBlock__
        int sum = a + b + 1;
        NSLog(@"sum is %d %@", sum, self);
    };
    return mallocBlock;
}

+ (id)block3 {
    __block int sum = 1;
    void (^mallocBlock)(void) = ^{
        // Note: __NSMallocBlock__
        sum = a + b + 1;
        NSLog(@"sum is %d", sum);
    };
    return mallocBlock;
}

@end

