//
//  WCBlockTool.m
//  HelloBlocks
//
//  Created by wesley_chen on 21/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "WCBlockTool.h"

@implementation WCBlockTool

// @see https://gist.github.com/steipete/6ee378bd7d87f276f6e0
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

