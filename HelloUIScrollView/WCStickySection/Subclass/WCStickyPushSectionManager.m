//
//  WCStickyPushSectionManager.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStickyPushSectionManager.h"
#import "WCStickySection_Internal.h"

@interface WCStickyPushSectionManager ()
@property (nonatomic, strong) NSMutableArray<WCStickySection *> *sections;
@end

@implementation WCStickyPushSectionManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView {
    self = [super initWithScrollView:scrollView];
    if (self) {
        _sections = [NSMutableArray array];
    }
    return self;
}

- (BOOL)addStickySection:(WCStickySection *)section atNextOffsetY:(CGFloat)nextOffsetY {
    CGFloat totalFixedHeight = 0;
    WCStickySection *firstStickySection = nil;
    for (WCStickySection *section in self.sections) {
        if (section.sticky) {
            if (!firstStickySection) {
                firstStickySection = section;
            }
            
            totalFixedHeight += CGRectGetHeight(section.bounds);
        }
    }
    if (firstStickySection) {
        section.fixedY = firstStickySection.fixedY + totalFixedHeight;
    }
    
    WCStickySection *lastSection = [self.sections lastObject];
    CGFloat initialY = CGRectGetMaxY(lastSection.frame) + nextOffsetY;
    [super addStickySection:section atInitialY:initialY];
    
    [self.sections addObject:section];
    
    return YES;
}

@end
