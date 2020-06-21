//
//  AnimationDemoView.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/20.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "AnimationDemoView.h"

@implementation AnimationDemoView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self addGestureRecognizer:tapGesture];
        
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        self.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    }
    return self;
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    if (tappedView == self) {
        !self.doAnimation ?: self.doAnimation();
    }
}


@end
