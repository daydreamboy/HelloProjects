//
//  WCStickyPushSectionManager.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/9.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WCStickySection.h"

NS_ASSUME_NONNULL_BEGIN

#warning "WCStickyPushSectionManager unfinished"
@interface WCStickyPushSectionManager : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
- (BOOL)addStickySection:(WCStickySection *)section atNextOffsetY:(CGFloat)nextOffsetY;

#pragma mark - UNAVAILABLE

- (BOOL)addStickySection:(WCStickySection *)section atInitialY:(CGFloat)initialY UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
