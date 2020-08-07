//
//  WCStickyHeaderSectionManager.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "WCStickyHeaderSection.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCStickyHeaderSectionManager : NSObject

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
- (BOOL)addStickyHeaderSection:(WCStickyHeaderSection *)section;
- (void)viewDidLayoutSubviews;

@end

NS_ASSUME_NONNULL_END
