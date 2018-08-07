//
//  MPMShareLiveView.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MPMShareLiveView.h"
#import "WCStringTool.h"
#import "WCMacroTool.h"
#import "WCImageTool.h"

@implementation MPMShareLiveView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 240, 260);
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self addSubview:self.imageViewPreview];
        [self addSubview:self.buttonPlay];
        [self addSubview:self.viewMaskedGradient];
        [self addSubview:self.labelTitle];
        [self addSubview:self.imageViewSourceIcon];
        [self addSubview:self.labelSourceTitle];
        [self addSubview:self.buttonPlayback];
        [self addSubview:self.imageViewAvatar];
        [self addSubview:self.labelAvatarName];
    }
}

#pragma mark - Getters

- (UIImageView *)imageViewPreview {
    if (!_imageViewPreview) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 190)];
        _imageViewPreview = imageView;
    }
    
    return _imageViewPreview;
}

- (UIButton *)buttonPlay {
    if (!_buttonPlay) {
        CGFloat side = 50;
        CGFloat x = CGRectGetMidX(self.imageViewPreview.frame) - side / 2.0;
        CGFloat y = CGRectGetMidY(self.imageViewPreview.frame) - side / 2.0;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(x, y, side, side);
        [button setBackgroundImage:[UIImage imageNamed:@"i_video_play"] forState:UIControlStateNormal];
        
        _buttonPlay = button;
    }
    
    return _buttonPlay;
}

- (UIView *)viewMaskedGradient {
    if (!_viewMaskedGradient) {
        CGFloat height = 48;
        CGFloat y = CGRectGetMaxY(self.imageViewPreview.frame) - height;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, y, CGRectGetWidth(self.bounds), height)];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = view.bounds;
        gradientLayer.colors = @[(id)[[UIColor clearColor] CGColor], (id)[[[UIColor blackColor] colorWithAlphaComponent:0.5] CGColor]];
        gradientLayer.startPoint = CGPointMake(0.5, 0);
        gradientLayer.endPoint = CGPointMake(0.5, 1);
        [view.layer insertSublayer:gradientLayer atIndex:0];
        
        _viewMaskedGradient = view;
    }
    
    return _viewMaskedGradient;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        CGFloat y = CGRectGetMaxY(self.imageViewPreview.frame) + 10;
        CGFloat width = CGRectGetWidth(self.bounds) - 2 * 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, y, width, 0)];
        label.numberOfLines = 2;
        label.text = self.title;
        label.font = [UIFont systemFontOfSize:14];
        label.textColor = UICOLOR_RGB(0x333333);
        
        CGSize textSize = [WCStringTool textSizeWithSingleLineString:label.text font:label.font];
        label.frame = CGRectMake(10, y, width, label.numberOfLines * textSize.height);
        
        _labelTitle = label;
    }
    
    return _labelTitle;
}

- (UIImageView *)imageViewSourceIcon {
    if (!_imageViewSourceIcon) {
        CGFloat side = 13;
        CGFloat x = CGRectGetMinX(self.labelTitle.frame);
        CGFloat y = CGRectGetHeight(self.bounds) - side - 10;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, side, side)];
        imageView.layer.cornerRadius = side / 2.0;
        imageView.layer.masksToBounds = YES;
        
        _imageViewSourceIcon = imageView;
    }
    
    return _imageViewSourceIcon;
}

- (UILabel *)labelSourceTitle {
    if (!_labelSourceTitle) {
        CGFloat x = CGRectGetMaxX(self.imageViewSourceIcon.frame) + 3;
        CGFloat y = CGRectGetMinY(self.imageViewSourceIcon.frame);
        CGFloat width = CGRectGetMaxX(self.labelTitle.frame) - x;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 13)];
        label.textColor = UICOLOR_RGB(0xbbbbbb);
        label.font = [UIFont systemFontOfSize:12];
        label.text = self.sourceTitle;
        
        _labelSourceTitle = label;
    }
    
    return _labelSourceTitle;
}

- (UIButton *)buttonPlayback {
    if (!_buttonPlayback) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:10];
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.contentMode = UIViewContentModeCenter;
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button setTitle:self.playbackTitle forState:UIControlStateNormal];
        [button setBackgroundImage:[WCImageTool imageWithColor:UICOLOR_RGB(0x2B9AFF)] forState:UIControlStateNormal];
        [button sizeToFit];
        
        CGSize textSize = [WCStringTool textSizeWithSingleLineString:button.titleLabel.text font:button.titleLabel.font];
        CGFloat width = textSize.width + 2 * 5;
        CGFloat height = textSize.height + 2 * 3;
        CGFloat x = CGRectGetWidth(self.bounds) - width - 10;
        CGFloat y = CGRectGetMaxY(self.imageViewPreview.frame) - height - 10;
        
        button.frame = CGRectMake(x, y, width, height);
        button.layer.cornerRadius = CGRectGetHeight(button.bounds) / 2.0;
        button.layer.masksToBounds = YES;
        
        _buttonPlayback = button;
    }
    
    return _buttonPlayback;
}

- (UIImageView *)imageViewAvatar {
    if (!_imageViewAvatar) {
        CGFloat side = 18;
        CGFloat y = CGRectGetMaxY(self.imageViewPreview.frame) - side - 10;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, y, side, side)];
        imageView.layer.borderColor = [UIColor whiteColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.layer.cornerRadius = side / 2.0;
        imageView.layer.masksToBounds = YES;
        
        imageView.backgroundColor = [UIColor lightGrayColor];
        
        _imageViewAvatar = imageView;
    }
    
    return _imageViewAvatar;
}

- (UILabel *)labelAvatarName {
    if (!_labelAvatarName) {
        CGFloat height = 13;
        CGFloat x = CGRectGetMaxX(self.imageViewAvatar.frame) + 3;
        CGFloat y = CGRectGetMidY(self.imageViewAvatar.frame) - height / 2.0;
        CGFloat width = CGRectGetMinX(self.buttonPlayback.frame) - x - 3;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, height)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor whiteColor];
        
        _labelAvatarName = label;
    }
    
    return _labelAvatarName;
}

@end




















