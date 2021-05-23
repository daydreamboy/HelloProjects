//
//  GlobalAndMallocBlocks.m
//  HelloBlocks
//
//  Created by wesley_chen on 27/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MallocBlocks.h"

static int m_a = 0;
int m_b = 1;
const int m_c = 2;

@implementation MallocBlocks

+ (id)block1 {
    int a = 1;
    void (^mallocBlock)(void) = ^{
        // Note: __NSMallocBlock__
        int sum = a + m_b + 1;
        NSLog(@"sum is %d", sum);
    };
    return mallocBlock;
}

+ (id)block2 {
    void (^mallocBlock)(void) = ^{
        // Note: __NSMallocBlock__
        int sum = m_a + m_b + 1;
        NSLog(@"sum is %d %@", sum, self);
    };
    return mallocBlock;
}

+ (id)block3 {
    __block int sum = 1;
    void (^mallocBlock)(void) = ^{
        // Note: __NSMallocBlock__
        sum = m_a + m_b + 1;
        NSLog(@"sum is %d", sum);
    };
    return mallocBlock;
}

@end

