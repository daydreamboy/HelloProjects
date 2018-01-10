//
//  CrashMaker.m
//  UnsafeFramework
//
//  Created by wesley_chen on 10/01/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "CrashMaker.h"

@implementation CrashMaker
- (void)makeAnUnrecognizedMethodException {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    [self performSelector:NSSelectorFromString(@"noneExsitedMethod:")];
#pragma GCC diagnostic pop
}
@end
