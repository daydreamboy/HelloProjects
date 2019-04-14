//
//  HipsterLabel.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "HipsterLabel.h"

@implementation HipsterLabel

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return (action == @selector(copy:) || action == @selector(customAction:));
}

- (void)copy:(id)sender {
    [UIPasteboard generalPasteboard].string = self.text;
}

- (void)customAction:(id)sender {
    NSLog(@"customAction clicked");
}

@end
