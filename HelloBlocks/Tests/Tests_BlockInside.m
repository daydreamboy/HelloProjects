//
//  Tests_BlockInside.m
//  Tests
//
//  Created by wesley_chen on 2021/5/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <dispatch/dispatch.h>

typedef void(^BlockA)(void);

__attribute__((noinline))
void runBlockA(BlockA block) {
    block();
}

void doBlockA() {
    BlockA block = ^{
        // Empty block
    };
    runBlockA(block);
}
