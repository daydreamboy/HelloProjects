//
//  WCKeyboardObserver.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/8/31.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCKeyboardObserver.h"

@interface WCKeyboardObserver ()
@property (nonatomic, weak) id observee;
@end

@implementation WCKeyboardObserver

- (instancetype)initWithObservee:(nullable id)observee; {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:observee];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:observee];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIKeyboardWillChangeFrameNotification:) name:UIKeyboardWillChangeFrameNotification object:observee];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:_observee];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:_observee];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:_observee];
}

- (void)registerObserverWithKeyboardWillAnimate:(WCKeyboardObserverKeyboardWillAnimate)willAnimate inAnimate:(WCKeyboardObserverKeyboardInAnimate)inAnimate didAnimate:(WCKeyboardObserverKeyboardDidAnimate)didAnimate {
    self.willAnimateBlock = willAnimate;
    self.inAnimateBlock = inAnimate;
    self.didAnimateBlock = didAnimate;
}

- (void)registerObserverWithKeyboardWillChangeFrame:(WCKeyboardObserverKeyboardWillChangeFrame)willChangeFrame inChangeFrame:(WCKeyboardObserverKeyboardInChangeFrame)inChangeFrame didChangeFrame:(WCKeyboardObserverKeyboardDidChangeFrame)didChangeFrame {
    self.willChangeFrameBlock = willChangeFrame;
    self.inChangeFrameBlock = inChangeFrame;
    self.didChangeFrameBlock = didChangeFrame;
}

#pragma mark - NSNotification

- (void)handleUIKeyboardWillShowNotification:(NSNotification *)notification {
    [self handleUIKeyboardWillShowNotification:notification isShowing:YES];
}

- (void)handleUIKeyboardWillHideNotification:(NSNotification *)notification {
    [self handleUIKeyboardWillShowNotification:notification isShowing:NO];
}

- (void)handleUIKeyboardWillChangeFrameNotification:(NSNotification *)notification {
    // getting keyboard animation attributes
    CGRect keyboardRectEnd = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    !self.willChangeFrameBlock ?: self.willChangeFrameBlock(keyboardRectEnd, duration);
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [UIView setAnimationCurve:curve];
        !self.inChangeFrameBlock ?: self.inChangeFrameBlock(keyboardRectEnd, duration);
    } completion:^(BOOL finished) {
        !self.didChangeFrameBlock ?: self.didChangeFrameBlock(finished);
    }];
}

#pragma mark ::

- (void)handleUIKeyboardWillShowNotification:(NSNotification *)notification isShowing:(BOOL)isShowing {
    // getting keyboard animation attributes
    CGRect keyboardRectEnd = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    UIViewAnimationCurve curve = [[notification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];
    NSTimeInterval duration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    !self.willAnimateBlock ?: self.willAnimateBlock(keyboardRectEnd, duration, isShowing);
    
    [UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [UIView setAnimationCurve:curve];
        !self.inAnimateBlock ?: self.inAnimateBlock(keyboardRectEnd, duration, isShowing);
    } completion:^(BOOL finished) {
        !self.didAnimateBlock ?: self.didAnimateBlock(finished, isShowing);
    }];
}

#pragma mark ::

@end
