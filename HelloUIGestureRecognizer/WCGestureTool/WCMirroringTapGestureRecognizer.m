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

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    // Note: check the mirroredTapGestureRecognizer if exists. If not exists, the mrroringTapGestureRecognizer should not continue mirroring
    return self.mirroredTapGestureRecognizer ? YES : NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end
