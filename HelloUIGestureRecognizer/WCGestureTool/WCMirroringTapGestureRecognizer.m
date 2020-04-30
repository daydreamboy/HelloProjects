//
//  WCMirroringTapGestureRecognizer.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/4/29.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCMirroringTapGestureRecognizer.h"

@interface WCMirroringTapGestureRecognizer () <UIGestureRecognizerDelegate>
@property (nonatomic, weak, readwrite) UITapGestureRecognizer *mirroredTapGestureRecognizer;
@end

@implementation WCMirroringTapGestureRecognizer

- (instancetype)initWithTarget:(id)target action:(SEL)action mirroredTapGestureRecognizer:(UITapGestureRecognizer *)mirroredTapGestureRecognizer {
    self = [super initWithTarget:target action:action];
    if (self) {
        self.delegate = self;
        self.mirroredTapGestureRecognizer = mirroredTapGestureRecognizer;
    }
    return self;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

// @see https://stackoverflow.com/questions/15457205/exclude-subviews-from-uigesturerecognizer
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    // Note: accept only touchs on view which attached current tap gesture, not accept touchs on its subviews
    if (touch.view != self.view) {
        return NO;
    }
    
    // Note: check the mirroredTapGestureRecognizer if exists. If not exists, the mrroringTapGestureRecognizer should not continue mirroring
    return self.mirroredTapGestureRecognizer ? YES : NO;
}

@end
