//
//  WCGCDTool.m
//  HelloGCD
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "WCGCDTool.h"

@implementation WCGCDTool
/// @see https://stackoverflow.com/a/10341532
+ (void)safePerformBlockOnMainQueue:(void (^)(void))block {
    if (block) {
        if ([NSThread isMainThread]) {
            block();
        }
        else {
            dispatch_async(dispatch_get_main_queue(), block);
        }
    }
}
@end
