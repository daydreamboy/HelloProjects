//
//  WCThreadTool.m
//  HelloThread
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "WCThreadTool.h"

@interface NSObject (WCThreadTool)
- (void)WCThreadTool_callBlock;
- (void)WCThreadTool_callBlockWithObject:(id)object;
@end

@implementation NSObject (WCThreadTool)

- (void)WCThreadTool_callBlock {
    dispatch_block_t block = (id)self;
    if (block) {
        block();
    }
}

- (void)WCThreadTool_callBlockWithObject:(id)object {
    void (^block)(id) = (id)self;
    if (block) {
        block(object);
    }
}

@end

@implementation WCThreadTool

+ (void)performBlock:(dispatch_block_t)block onThread:(NSThread *)thread waitUntilDone:(BOOL)waitUntilDone {
    if (block && [thread isKindOfClass:[NSThread class]]) {
        dispatch_block_t blockCopy = [block copy];
        [blockCopy performSelector:@selector(WCThreadTool_callBlock) onThread:thread withObject:nil waitUntilDone:waitUntilDone];
    }
}

+ (void)performBlock:(void (^)(id))block onThread:(NSThread *)thread withObject:(id)object waitUntilDone:(BOOL)waitUntilDone {
    if (block && [thread isKindOfClass:[NSThread class]]) {
        dispatch_block_t blockCopy = [block copy];
        [blockCopy performSelector:@selector(WCThreadTool_callBlockWithObject:) onThread:thread withObject:object waitUntilDone:waitUntilDone];
    }
}

@end
