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

@interface WCStickySection (Header)
/**
 The priority of sorting. Default is 0
 
 @discussion If the priority is bigger, this header section is possibly arranged at the topmost than other sections
 */
@property (nonatomic, assign) NSInteger priority;
/**
 Set to auto adjust section's fixedY
 
 @discussion If set YES, the previous one is sticky, this section is sticky after the previous one
 @note This property only works when the section is sticky and ignore value in initWithFixedY: method
 */
@property (nonatomic, assign) BOOL autoFixed;
@end

@interface WCStickyHeaderSectionManager : WCStickySectionManager

@property (nonatomic, strong, readonly) NSMutableArray<WCStickySection *> *sortedSections;

- (instancetype)initWithScrollView:(UIScrollView *)scrollView;
- (void)viewDidLayoutSubviews;

- (BOOL)addStickyHeaderSection:(WCStickySection *)section;
- (BOOL)addStickyHeaderSection:(WCStickySection *)section priority:(NSInteger)priority;
- (void)changeStickyHeaderSection:(WCStickySection *)section toHeight:(CGFloat)height;

#pragma mark - UNAVAILABLE

- (BOOL)addStickySection:(WCStickySection *)section atInitialY:(CGFloat)initialY UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
