//
//  BlockInside_helper.m
//  HelloBlocks
//
//  Created by wesley_chen on 2021/5/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "BlockInside_helper.h"

typedef void(^BlockC)(void);

//extern void foo(int) __attribute__((weak));

void foo(int) {
    
}

__attribute__((noinline))
void runBlockC(BlockC block) {
    block();
}

void doBlockC() {
    __block int a = 128;
    BlockC block = ^{
        foo(a);
    };
    runBlockC(block);
}
