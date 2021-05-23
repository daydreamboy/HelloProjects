//
//  BlockInside_BlockVariable.m
//  HelloBlocks
//
//  Created by wesley_chen on 2021/5/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "BlockInside_BlockVariable.h"

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
