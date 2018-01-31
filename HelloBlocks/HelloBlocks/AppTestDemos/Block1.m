//
//  Block1.m
//  HelloBlocks
//
//  Created by wesley_chen on 29/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

void (^callback)(void) = ^{
    // Note: __NSGlobalBlock__
    NSLog(@"hello, world");
};
