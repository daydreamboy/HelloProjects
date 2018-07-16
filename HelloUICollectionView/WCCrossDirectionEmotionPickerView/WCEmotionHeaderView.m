//
//  WCEmotionHeaderView.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/13.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCEmotionHeaderView.h"

@interface WCEmotionHeaderView ()
@property (nonatomic, strong, readwrite) UILabel *textLabel;
@end

@implementation WCEmotionHeaderView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLabel];
    }
    return self;
}

#pragma mark - Getters

- (UILabel *)textLabel {
    if (!_textLabel) {
        UILabel *label = [[UILabel alloc] initWithFrame:self.bounds];
        
        _textLabel = label;
    }
    
    return _textLabel;
}

@end
