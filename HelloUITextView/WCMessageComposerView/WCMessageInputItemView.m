//
//  WCMessageInputItemView.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/24.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCMessageInputItemView.h"
#import "WCFontTool.h"

@interface WCMessageInputItemView ()
@property (nonatomic, strong) WCMessageInputItem *item;
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UIImageView *imageViewImage;
@property (nonatomic, strong) UIView *customView;
@end

@implementation WCMessageInputItemView

- (instancetype)initWithItem:(WCMessageInputItem *)item {
    self = [super initWithFrame:CGRectMake(0, 0, item.size.width, item.size.height)];
    if (self) {
        _item = item;
        
        switch (item.type) {
            case WCMessageInputItemTypeText: {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
                label.text = item.title;
                label.font = [WCFontTool adaptiveFontWithInitialFont:item.titleFont minimumFontSize:item.titleMinimumFontSize contrainedSize:item.size mutilpleLines:NO textString:item.title];
                [label sizeToFit];
                [self addSubview:label];
                _labelText = label;
                
                [self setOrigin:CGPointZero];
                break;
            }
            case WCMessageInputItemTypeIconFont: {
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, item.size.width, item.size.height)];
                label.text = item.title;
                label.font = item.titleFont;
                [label sizeToFit];
                label.center = CGPointMake(item.size.width / 2.0, item.size.height / 2.0);
                [self addSubview:label];
                
                _labelText = label;
                break;
            }
            case WCMessageInputItemTypeLocalImage: {
                UIImageView *imageView = [[UIImageView alloc] initWithImage:item.iconImage];
                imageView.frame = CGRectMake(0, 0, item.iconImage.size.width, item.iconImage.size.height);
                imageView.center = CGPointMake(item.size.width / 2.0, item.size.height / 2.0);
                [self addSubview:imageView];
                
                _imageViewImage = imageView;
                break;
            }
            case WCMessageInputItemTypeRemoteImage: {
                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, item.iconImage.size.width, item.iconImage.size.height)];
                imageView.center = CGPointMake(item.size.width / 2.0, item.size.height / 2.0);
                [self addSubview:imageView];
                
                _imageViewImage = imageView;
                break;
            }
            case WCMessageInputItemTypeCustomView: {
                UIView *customView = item.customView;
                customView.center = CGPointMake(item.size.width / 2.0, item.size.height / 2.0);
                [self addSubview:customView];
                
                _customView = customView;
                break;
            }
        }
    }
    return self;
}

- (void)setOrigin:(CGPoint)origin {
    _origin = origin;
    
    if (_item.type == WCMessageInputItemTypeText) {
        CGFloat width = MAX(_item.size.width, _labelText.bounds.size.width);
        self.frame = CGRectMake(origin.x, origin.y, width, self.item.size.height);
        _labelText.center = CGPointMake(width / 2.0, _item.size.height / 2.0);
    }
    else {
        self.frame = CGRectMake(origin.x, origin.y, self.item.size.width, self.item.size.height);
    }
}

#pragma mark -

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
