//
//  MPMShareCommodityView.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MPMShareCommodityView.h"
#import "WCMacroTool.h"

@implementation MPMShareCommodityView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 240, 120);
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        
        [self addSubview:self.imageViewCommodityPreview];
        [self addSubview:self.labelTitle];
        [self addSubview:self.labelSubtitle];
        [self addSubview:self.labelPrice];
        [self addSubview:self.labelNumberOfOrders];
        [self addSubview:self.buttonLeft];
        [self addSubview:self.buttonRight];
        [self addSubview:self.imageViewSourceIcon];
        [self addSubview:self.labelSourceTitle];
        [self addSubview:self.labelSourceSubtitle];
        [self addSubview:self.imageViewCoupon];
        [self addSubview:self.imageViewStamp];
        [self sendSubviewToBack:self.imageViewStamp];
    }
    return self;
}

#pragma mark - Getters

- (UIImageView *)imageViewCommodityPreview {
    if (!_imageViewCommodityPreview) {
        CGFloat side = 80;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, side, side)];
        imageView.layer.cornerRadius = 3;
        
        _imageViewCommodityPreview = imageView;
    }
    
    return _imageViewCommodityPreview;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        CGFloat x = CGRectGetMaxX(self.imageViewCommodityPreview.frame) + 10;
        CGFloat y = CGRectGetMinY(self.imageViewCommodityPreview.frame);
        CGFloat width = CGRectGetWidth(self.bounds) - CGRectGetMaxY(self.imageViewCommodityPreview.frame) - 2 * 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 37)];
        label.numberOfLines = 2;
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        
        _labelTitle = label;
    }
    
    return _labelTitle;
}

- (UILabel *)labelSubtitle {
    if (!_labelSubtitle) {
        CGFloat x = CGRectGetMaxX(self.imageViewCommodityPreview.frame) + 10;
        CGFloat y = CGRectGetMaxY(self.labelTitle.frame) + 5;
        CGFloat width = CGRectGetWidth(self.labelTitle.frame);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 13)];
        label.textColor = UICOLOR_RGB(0xff5000);
        
        _labelSubtitle = label;
    }
    
    return _labelSubtitle;
}

- (UILabel *)labelPrice {
    if (!_labelPrice) {
        CGFloat x = CGRectGetMaxX(self.imageViewCommodityPreview.frame) + 10;
        CGFloat y = CGRectGetMaxY(self.labelTitle.frame) + 5;
        CGFloat width = CGRectGetWidth(self.labelTitle.frame);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 13)];
        label.textColor = UICOLOR_RGB(0xff5000);
        label.textAlignment = NSTextAlignmentLeft;
        
        _labelPrice = label;
    }
    
    return _labelPrice;
}

- (UILabel *)labelNumberOfOrders {
    if (!_labelNumberOfOrders) {
        CGFloat x = CGRectGetMaxX(self.imageViewCommodityPreview.frame) + 10;
        CGFloat y = CGRectGetMaxY(self.labelTitle.frame) + 5;
        CGFloat width = CGRectGetWidth(self.labelTitle.frame);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 13)];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        
        _labelNumberOfOrders = label;
    }
    
    return _labelNumberOfOrders;
}

- (UIButton *)buttonLeft {
    if (!_buttonLeft) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.cornerRadius = 10;
        
        CGFloat x = CGRectGetMinX(self.labelTitle.frame);
        CGFloat y = CGRectGetMaxY(self.labelSubtitle.frame) + 5;
        CGFloat width = (CGRectGetWidth(self.labelTitle.frame) - 10) / 2.0;
        
        button.frame = CGRectMake(x, y, width, 20);
        
        _buttonLeft = button;
    }
    
    return _buttonLeft;
}

- (UIButton *)buttonRight {
    if (!_buttonRight) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        button.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        button.layer.cornerRadius = 10;
        
        CGFloat width = CGRectGetWidth(self.buttonLeft.frame);
        CGFloat x = CGRectGetMaxX(self.labelTitle.frame) - width;
        CGFloat y = CGRectGetMaxY(self.labelSubtitle.frame) + 5;
        
        button.frame = CGRectMake(x, y, width, 20);
        
        _buttonRight = button;
    }
    
    return _buttonRight;
}

- (UIImageView *)imageViewSourceIcon {
    if (!_imageViewSourceIcon) {
        CGFloat side = 13;
        CGFloat x = CGRectGetMinX(self.imageViewCommodityPreview.frame);
        CGFloat y = CGRectGetMaxY(self.imageViewCommodityPreview.frame) + 10;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, side, side)];
        imageView.layer.cornerRadius = side / 2.0;
        
        _imageViewSourceIcon = imageView;
    }
    
    return _imageViewSourceIcon;
}

- (UILabel *)labelSourceTitle {
    if (!_labelSourceTitle) {
        CGFloat x = CGRectGetMaxX(self.imageViewSourceIcon.frame) + 3;
        CGFloat y = CGRectGetMaxY(self.imageViewCommodityPreview.frame) + 10;
        CGFloat width = CGRectGetMaxX(self.labelTitle.frame) - CGRectGetMaxX(self.imageViewSourceIcon.frame) - 3;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 13)];
        label.textColor = [UIColor lightGrayColor];
        
        _labelSourceTitle = label;
    }
    
    return _labelSourceTitle;
}

- (UILabel *)labelSourceSubtitle {
    if (!_labelSourceSubtitle) {
        CGFloat width = CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.imageViewCommodityPreview.frame) - 10;
        CGFloat x = CGRectGetWidth(self.bounds) - width - 10;
        CGFloat y = CGRectGetMaxY(self.imageViewCommodityPreview.frame) + 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 13)];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        
        _labelSourceSubtitle = label;
    }
    
    return _labelSourceSubtitle;
}

- (UIImageView *)imageViewCoupon {
    if (!_imageViewCoupon) {
        CGFloat width = 36;
        CGFloat x = CGRectGetMaxX(self.labelTitle.frame) - width - 10;
        CGFloat y = CGRectGetMaxY(self.labelTitle.frame) + 5;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, width, 12)];
        
        _imageViewCoupon = imageView;
    }
    
    return _imageViewCoupon;
}

- (UIImageView *)imageViewStamp {
    if (!_imageViewStamp) {
        CGFloat side = 55;
        CGFloat x = CGRectGetMaxX(self.bounds) - side;
        CGFloat y = CGRectGetMaxY(self.bounds) - side;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, side, side)];
        
        _imageViewStamp = imageView;
    }
    
    return _imageViewStamp;
}

@end

























