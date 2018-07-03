//
//  MyViewWithUIAppearance.m
//  HelloUIAppearance
//
//  Created by wesley_chen on 2018/7/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MyViewWithUIAppearance.h"

@implementation MyViewWithUIAppearance

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        self.backgroundColor = self.myBackgroundColor;
    }
}

#pragma mark - UIAppearance

- (void)setMyBackgroundColor:(UIColor *)myBackgroundColor {
    _myBackgroundColor = myBackgroundColor;
    self.backgroundColor = myBackgroundColor;
}

- (void)setMyBorderColor:(UIColor *)myBorderColor {
    _myBorderColor = myBorderColor;
    self.layer.borderColor = myBorderColor.CGColor;
}

- (void)setMyBorderWidth:(CGFloat)myBorderWidth {
    _myBorderWidth = myBorderWidth;
    self.layer.borderWidth = myBorderWidth;
}

@end
