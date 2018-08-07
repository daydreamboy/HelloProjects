//
//  MPMShareLinkView.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MPMShareLinkView.h"
#import "WCStringTool.h"
#import "WCMacroTool.h"

@implementation MPMShareLinkView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, 240, 90);
        self.layer.cornerRadius = 12;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        [self addSubview:self.imageViewPreview];
        
        if (self.imageViewPreviewHidden) {
            CGRect frame = self.imageViewPreview.frame;
            frame.size.width = 0;
            frame.size.height = 0;
            self.imageViewPreview.frame = frame;
        }
        
        [self addSubview:self.labelTitle];
        [self addSubview:self.labelSubtitle];
        [self addSubview:self.imageViewSourceIcon];
        [self addSubview:self.labelSourceTitle];
        [self addSubview:self.labelSourceSubtitle];
        [self addSubview:self.imageViewStamp];
        [self sendSubviewToBack:self.imageViewStamp];
    }
}

#pragma mark - Getters

- (UIImageView *)imageViewPreview {
    if (!_imageViewPreview) {
        CGFloat side = 50;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, side, side)];
        imageView.layer.cornerRadius = 3;
        
        _imageViewPreview = imageView;
    }
    
    return _imageViewPreview;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        CGFloat x = CGRectGetMaxX(self.imageViewPreview.frame) + 10;
        CGFloat width = CGRectGetWidth(self.bounds) - x - 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, 10, width, 0)];
        label.numberOfLines = self.numberOfLinesForTitle;
        label.text = self.title;
        label.font = [UIFont systemFontOfSize:14];
        
        CGSize textSize = [WCStringTool textSizeWithSingleLineString:label.text font:label.font];
        label.frame = CGRectMake(x, 10, width, textSize.height * self.numberOfLinesForTitle);
        
        _labelTitle = label;
    }
    
    return _labelTitle;
}

- (UILabel *)labelSubtitle {
    if (!_labelSubtitle) {
        CGFloat x = CGRectGetMaxX(self.imageViewPreview.frame) + 10;
        CGFloat width = CGRectGetWidth(self.bounds) - x - 10;
        CGFloat y = CGRectGetMaxY(self.labelTitle.frame) + 5;
        UIFont *font = [UIFont systemFontOfSize:12];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, font.lineHeight)];
        label.font = font;
        label.text = self.subtitle;
        label.textColor = self.subtitleColor ?: UICOLOR_RGB(0x999999);
        
        _labelSubtitle = label;
    }
    
    return _labelSubtitle;
}

- (UIImageView *)imageViewSourceIcon {
    if (!_imageViewSourceIcon) {
        CGFloat side = 13;
        CGFloat x = CGRectGetMinX(self.imageViewPreview.frame);
        CGFloat y = CGRectGetHeight(self.bounds) - side - 10;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, y, side, side)];
        imageView.layer.cornerRadius = side / 2.0;
        
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
        [label sizeToFit];
        
        _labelSourceTitle = label;
    }
    
    return _labelSourceTitle;
}

- (UILabel *)labelSourceSubtitle {
    if (!_labelSourceSubtitle) {
        CGFloat width = CGRectGetWidth(self.bounds) - CGRectGetMaxX(self.labelSourceTitle.frame) - 10;
        CGFloat x = CGRectGetWidth(self.bounds) - width - 10;
        CGFloat y = CGRectGetMinY(self.imageViewSourceIcon.frame);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, width, 13)];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentRight;
        
        _labelSourceSubtitle = label;
    }
    
    return _labelSourceSubtitle;
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



















