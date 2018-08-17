//
//  WCBaseHorizontalPage.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCBaseHorizontalPage.h"
#import "WCBaseHorizontalPage_Internal.h"

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

@interface WCBaseHorizontalPage ()
@property (nonatomic, strong) UIView *pageContentView;
@end

@implementation WCBaseHorizontalPage

@dynamic pageSpace;

static CGFloat sPageSpace;

+ (void)setPageSpace:(CGFloat)pageSpace {
    sPageSpace = pageSpace;
}

+ (CGFloat)pageSpace {
    return sPageSpace;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGRect contentFrame = CGRectMake(sPageSpace / 2.0, 0, frame.size.width - sPageSpace, frame.size.height);
        
        _pageContentView = [[UIView alloc] initWithFrame:contentFrame];
        // DEBUG: turn on backgroundColor
        //_pageContentView.backgroundColor = UICOLOR_randomColor;
        [self addSubview:_pageContentView];
    }
    return self;
}

@end
