//
//  WCStickyHeaderSectionManager.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WCStickySectionManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCStickyHeaderSectionManager : WCStickySectionManager

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
- (void)viewDidLayoutSubviews;

- (BOOL)addStickyHeaderSection:(WCStickySection *)section;
- (BOOL)addStickyHeaderSection:(WCStickySection *)section priority:(NSInteger)priority;

#pragma mark - UNAVAILABLE

- (BOOL)addStickySection:(WCStickySection *)section atInitialY:(CGFloat)initialY UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
