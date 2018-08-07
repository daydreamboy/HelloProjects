//
//  MPMShareStoreView.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MPMShareStoreView.h"

@implementation MPMShareStoreView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 240, 100);
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.imageViewPreview];
        [self addSubview:self.labelTitle];
        [self addSubview:self.labelSubtitle];
        [self addSubview:self.labelCenteredTitle];
        [self addSubview:self.viewFooter];
        [self addSubview:self.imageViewSourceIcon];
        [self addSubview:self.labelSourceTitle];
        [self addSubview:self.imageViewBackground];
        
        [self sendSubviewToBack:self.viewFooter];
        [self sendSubviewToBack:self.imageViewBackground];
    }
    return self;
}

#pragma mark - Getters

- (UIImageView *)imageViewPreview {
    if (!_imageViewPreview) {
        CGFloat side = 50;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, side, side)];
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.layer.cornerRadius = 3;
        
        _imageViewPreview = imageView;
    }
    
    return _imageViewPreview;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        CGFloat x = CGRectGetMaxX(self.imageViewPreview.frame) + 10;
        CGFloat y = 17.5;
        CGFloat width = CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.imageViewPreview.frame) - 2 * 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 13)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:14];
        
        _labelTitle = label;
    }
    
    return _labelTitle;
}

- (UILabel *)labelSubtitle {
    if (!_labelSubtitle) {
        CGFloat x = CGRectGetMaxX(self.imageViewPreview.frame) + 10;
        CGFloat y = CGRectGetMaxY(self.labelTitle.frame) + 10;
        CGFloat width = CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.imageViewPreview.frame) - 2 * 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 11.5)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        
        _labelSubtitle = label;
    }
    
    return _labelSubtitle;
}

- (UILabel *)labelCenteredTitle {
    if (!_labelCenteredTitle) {
        CGFloat height = 13;
        CGFloat x = CGRectGetMaxX(self.imageViewPreview.frame) + 10;
        CGFloat y = CGRectGetMidY(self.imageViewPreview.frame) - height / 2.0;
        CGFloat width = CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.imageViewPreview.frame) - 2 * 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:16];
     
        _labelCenteredTitle = label;
    }
    
    return _labelCenteredTitle;
}

- (UIView *)viewFooter {
    if (!_viewFooter) {
        CGFloat height = 30;
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat y = CGRectGetHeight(self.bounds) - height;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, width, height)];
        view.backgroundColor = [UIColor whiteColor];
        
        _viewFooter = view;
    }
    
    return _viewFooter;
}

- (UIImageView *)imageViewSourceIcon {
    if (!_imageViewSourceIcon) {
        CGFloat side = 13.0;
        CGFloat x = CGRectGetMinX(self.imageViewPreview.frame);
        CGFloat y = CGRectGetMinY(self.viewFooter.frame) + (CGRectGetHeight(self.viewFooter.frame) - side) / 2.0;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, side, side)];
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

- (UIImageView *)imageViewBackground {
    if (!_imageViewBackground) {
        CGFloat width = CGRectGetWidth(self.bounds);
        CGFloat height = CGRectGetHeight(self.bounds);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        
        _imageViewBackground = imageView;
    }
    
    return _imageViewBackground;
}

@end


















