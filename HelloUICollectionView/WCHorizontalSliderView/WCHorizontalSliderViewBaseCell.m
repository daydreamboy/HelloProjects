//
//  WCHorizontalSliderViewBaseCell.m
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/11.
//

#import "WCHorizontalSliderViewBaseCell.h"

@interface WCHorizontalSliderViewBaseCell ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation WCHorizontalSliderViewBaseCell
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.button];
        [self.contentView addSubview:self.imageView];
    }
    return self;
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView = imageView;
    }
    
    return _imageView;
}

- (UIButton *)button {
    if (!_button) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = self.bounds;
        button.userInteractionEnabled = NO;
        _button = button;
    }
    
    return _button;
}

@end
