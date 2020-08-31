//
//  WCStickySection.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCStickySection : UIView

@property (nonatomic, assign, readonly) CGFloat height;
/**
 This section is sticky if it scrolling reach to the fixed Y
 */
@property (nonatomic, assign) BOOL sticky;

- (instancetype)initWithFixedY:(CGFloat)fixedY height:(CGFloat)height;

#pragma mark - UNAVAILABLE

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithFrame:(CGRect)frame UNAVAILABLE_ATTRIBUTE;

@end

NS_ASSUME_NONNULL_END
