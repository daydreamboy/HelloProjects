//
//  WCResponderTool.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCResponderTool.h"

static __weak id sCurrentFirstResponder;

@interface UIResponder (WCResponderTool)
@end

@implementation UIResponder (WCResponderTool)
- (void)WCResponderTool_findFirstResponder:(id)sender {
    sCurrentFirstResponder = self;
}
@end

@implementation WCResponderTool

+ (nullable id)currentFirstResponder {
    sCurrentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(WCResponderTool_findFirstResponder:) to:nil from:nil forEvent:nil];
    return sCurrentFirstResponder;
}

@end
