//
//  WCEmotionItemView.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/12.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCEmotionItemView.h"

@interface WCEmotionItemView ()
@property (nonatomic, strong, readwrite) UIImageView *imageView;
@end

@implementation WCEmotionItemView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
    }
    return self;
}

#pragma mark - Getter

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat side = 32;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - side) / 2.0, ((self.bounds.size.height) - side) / 2.0, side, side)];
//        imageView.userInteractionEnabled = YES;
        _imageView = imageView;
    }
    
    return _imageView;
}

@end
