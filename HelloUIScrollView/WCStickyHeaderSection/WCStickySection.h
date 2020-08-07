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

@property (nonatomic, assign, readonly) CGFloat fixedY;
@property (nonatomic, assign, readonly) CGFloat height;
/**
 This section is sticky if it scrolling reach to the fixed Y
 */
@property (nonatomic, assign) BOOL sticky;
/**
 The priority of sorting. Default is 0
 
 @discussion If the priority is bigger, this header section is possibly arranged at the topmost than other sections
 */
@property (nonatomic, assign) NSInteger priority;

- (instancetype)initWithFixed:(CGFloat)fixedY height:(CGFloat)height;

@end

NS_ASSUME_NONNULL_END
