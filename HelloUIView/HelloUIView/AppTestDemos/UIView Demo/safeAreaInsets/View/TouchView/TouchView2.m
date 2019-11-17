//
//  TouchView2.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/12.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TouchView2.h"

#import "WCViewTool.h"

@interface TouchView2 ()
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UILabel *labelInsets;
@end

@implementation TouchView2

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blueColor];
        
        _labelText = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelText.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.3];
        _labelText.numberOfLines = 0;
        _labelText.font = [UIFont systemFontOfSize:16];
        _labelText.text = LONG_TEXT;
        _labelText.backgroundColor = [UIColor colorWithRed:255.0 / 255.0 green:190.0 / 255.0 blue:118.0 / 255.0 alpha:1];
        
        [self addSubview:_labelText];
        
        _labelInsets = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _labelInsets.numberOfLines = 0;
        _labelInsets.textColor = [UIColor blueColor];
        _labelInsets.font = [UIFont boldSystemFontOfSize:14];
        _labelInsets.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_labelInsets];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.labelText.frame = [WCViewTool safeAreaLayoutFrameWithView:self];
}

@end
