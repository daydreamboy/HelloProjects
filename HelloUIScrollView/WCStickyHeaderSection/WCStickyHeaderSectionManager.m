//
//  WCStickyHeaderSectionManager.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStickyHeaderSectionManager.h"
#import "WCStickySection_Internal.h"

@interface WCStickyHeaderSectionManager ()
@property (nonatomic, assign) CGFloat headerHeight;
@end

@implementation WCStickyHeaderSectionManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithScrollView:scrollView];
    if (self) {
        _headerHeight = 0;
    }
    return self;
}

- (BOOL)addStickyHeaderSection:(WCStickySection *)section {
    [super addStickyHeaderSection:section];
    
    self.headerHeight += section.height;
    
    CGFloat startY = -self.headerHeight;
    for (WCStickySection *section in self.sections) {
        section.frame = CGRectMake(0, startY, CGRectGetWidth(self.scrollView.bounds), section.height);;
        section.initialY = startY;
        
        startY += section.height;
    }
    
    self.scrollView.contentInset = UIEdgeInsetsMake(self.headerHeight, 0, 0, 0);
    
    return YES;
}

- (void)viewDidLayoutSubviews {
    self.scrollView.contentOffset = CGPointMake(0, -self.headerHeight);
}

@end
