//
//  WCStickyHeaderSection.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCStickyHeaderSection : UIView

@property (nonatomic, assign, readonly) CGFloat initialY;
@property (nonatomic, assign, readonly) CGFloat fixedY;
@property (nonatomic, assign, readonly) CGFloat height;
@property (nonatomic, assign) BOOL sticky;

- (instancetype)initWithInitialY:(CGFloat)initialY fixed:(CGFloat)fixedY height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
