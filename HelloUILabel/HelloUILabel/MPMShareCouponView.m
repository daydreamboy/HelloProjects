//
//  MPMShareCouponView.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MPMShareCouponView.h"

@implementation MPMShareCouponView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 240, 100);
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.imageViewBackground];
        [self addSubview:self.imageViewIcon];
        [self addSubview:self.labelTitle];
        [self addSubview:self.labelSubtitle];
        [self addSubview:self.viewFooter];
        [self addSubview:self.imageViewSourceIcon];
        [self addSubview:self.labelSourceTitle];
        [self addSubview:self.viewMaskSelected];
        
        [self sendSubviewToBack:self.viewFooter];
        [self sendSubviewToBack:self.imageViewBackground];
    }
    return self;
}

#pragma mark - Getters

- (UIImageView *)imageViewBackground {
    if (!_imageViewBackground) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        
        _imageViewBackground = imageView;
    }
    
    return _imageViewBackground;
}

- (UIImageView *)imageViewIcon {
    if (!_imageViewIcon) {
        CGFloat side = 35;
        CGFloat x = 15;
        CGFloat y = 17.5;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, side, side)];
        
        _imageViewIcon = imageView;
    }
    
    return _imageViewIcon;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        CGFloat x = CGRectGetMaxX(self.imageViewIcon.frame) + 10;
        CGFloat y = CGRectGetMinY(self.imageViewIcon.frame);
        CGFloat width = CGRectGetWidth(self.bounds) - x - 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 13)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        
        _labelTitle = label;
    }
    
    return _labelTitle;
}

- (UILabel *)labelSubtitle {
    if (!_labelSubtitle) {
        CGFloat x = CGRectGetMaxX(self.imageViewIcon.frame) + 10;
        CGFloat y = CGRectGetMaxY(self.labelTitle.frame) + 10;
        CGFloat width = CGRectGetWidth(self.bounds) - x - 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 13)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        
        _labelSubtitle = label;
    }
    
    return _labelSubtitle;
}

- (UIView *)viewFooter {
    if (!_viewFooter) {
        CGFloat height = 30;
        CGFloat y = CGRectGetHeight(self.bounds) - height;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.bounds), height)];
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.2];
        
        _viewFooter = view;
    }
    
    return _viewFooter;
}

- (UIImageView *)imageViewSourceIcon {
    if (!_imageViewSourceIcon) {
        CGFloat side = 13.0;
        CGFloat y = CGRectGetMinY(self.viewFooter.frame) + (CGRectGetHeight(self.viewFooter.frame) - side) / 2.0;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, side, side)];
        imageView.layer.cornerRadius = side / 2.0;
        
        _imageViewSourceIcon = imageView;
    }
    
    return _imageViewSourceIcon;
}

- (UILabel *)labelSourceTitle {
    if (!_labelSourceTitle) {
        CGFloat height = 13;
        CGFloat x = CGRectGetMaxX(self.imageViewSourceIcon.frame) + 10;
        CGFloat y = CGRectGetMinY(self.imageViewSourceIcon.frame);
        CGFloat width = CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.imageViewSourceIcon.frame) - 10 - 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        label.textColor = [UIColor lightGrayColor];
        label.font = [UIFont systemFontOfSize:12];
        
        _labelSourceTitle = label;
    }
    
    return _labelSourceTitle;
}

- (UIView *)viewMaskSelected {
    if (!_viewMaskSelected) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds))];
        view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
        
        _viewMaskSelected = view;
    }
    
    return _viewMaskSelected;
}

@end
















