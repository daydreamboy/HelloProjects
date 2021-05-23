//
//  StackBlocks.m
//  HelloBlocks
//
//  Created by wesley_chen on 27/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "StackBlocks.h"
#import "WCBlockTool.h"

#define STR_OF_BOOL(yesOrNo)     ((yesOrNo) ? @"YES" : @"NO")

static int a = 1;

@implementation StackBlocks
+ (id)test_block1 {
    int base = 100;
    // Note: __NSStackBlock__
    long (^stackBlock)(int) = ^ long (int b) {
        return base + a + b;
    };
    NSLog(@"1. %@", stackBlock);
    return stackBlock;
}

+ (id)test_block2 {
    __block int base = 100;
    // Note: __NSStackBlock__
    long (^stackBlock)(int) = ^ long (int b) {
        base += 1;
        return base + a + b;
    };
    NSLog(@"2. %@", stackBlock);
    return stackBlock;
}

+ (id)test_block3 {
    // Note: __NSStackBlock__
    void (^stackBlock)(void) = ^{
        NSLog(@"%@", self);
    };
    NSLog(@"3. %@", stackBlock);
    return stackBlock;
}

+ (id)test_block4 {
    // Note: __NSGlobalBlock__
    void (^globalBlock)(void) = ^{
        NSLog(@"some int: %d", a);
    };
    NSLog(@"4. %@", globalBlock);
    return globalBlock;
}

+ (id)test_block5 {
    // Note: __NSGlobalBlock__
    void (^globalBlock)(void) = ^{
        NSLog(@"some");
    };
    // Note: also __NSGlobalBlock__
    id globalBlockCopyed = [globalBlock copy];
    NSLog(@"5. %@", globalBlockCopyed);
    return globalBlockCopyed;
}

+ (id)test_block6 {
    __block int base = 100;
    // Note: __NSStackBlock__
    long (^stackBlock)(int) = ^ long (int b) {
        base += 1;
        return base + a + b;
    };
    // Note: __NSMallocBlock__
    id globalBlockCopyed = [stackBlock copy];
    NSLog(@"6. %@", globalBlockCopyed);
    return globalBlockCopyed;
}

#pragma mark - WCBlockTool

+ (void)test_isBlock_with_stack_blocks {
    int base = 100;
    // Note: __NSStackBlock__
    long (^stackBlock)(int) = ^ long (int b) {
        return base + a + b;
    };
    NSLog(@"is block: %@", STR_OF_BOOL([self isBlock:stackBlock]));
}

+ (BOOL)isBlock:(id _Nullable)block {
    static Class blockClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blockClass = [^{} class];
        while ([blockClass superclass] != [NSObject class]) {
            blockClass = [blockClass superclass];
        }
    });
    
    return [block isKindOfClass:blockClass];
}

@end
