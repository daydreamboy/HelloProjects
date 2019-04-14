//
//  MyTextField.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/4/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "MyTextFieldWithOverrideNexResponder.h"

@implementation MyTextFieldWithOverrideNexResponder

- (UIResponder *)nextResponder {
    if (_overrideNextResponder != nil) {
        return _overrideNextResponder;
    }
    else {
        return [super nextResponder];
    }
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (_overrideNextResponder != nil) {
        return NO;
    }
    else {
        return [super canPerformAction:action withSender:sender];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    // Note: relinquish the overrideNextResponder if the long press on the UITextField
    _overrideNextResponder = nil;
}

@end
