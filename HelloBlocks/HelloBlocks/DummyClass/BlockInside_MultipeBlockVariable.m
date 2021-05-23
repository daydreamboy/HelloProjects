//
//  BlockInside_MultipeBlockVariable.m
//  HelloBlocks
//
//  Created by wesley_chen on 2021/5/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "BlockInside_MultipeBlockVariable.h"

#import <dispatch/dispatch.h>

typedef void(^BlockB)(void);

__attribute__((noinline))
void runBlockB(BlockB block) {
    block();
}

void doBlockB() {
    BlockB block1 = ^{
        // Empty block
    };
    
    BlockB block2 = ^{
        // Empty block
    };
    
    runBlockB(block1);
    runBlockB(block2);
}
