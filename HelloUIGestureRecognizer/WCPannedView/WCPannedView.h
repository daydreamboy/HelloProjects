//
//  WCPannedView.h
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/7/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WCPannedView;

@protocol WCPannedViewDelegate <NSObject>
- (void)pannedViewDragBegin:(WCPannedView *)pannedView;
- (void)pannedViewDragMoving:(WCPannedView *)pannedView;
- (void)pannedViewDragEnd:(WCPannedView *)pannedView;
- (void)pannedViewDragCanelled:(WCPannedView *)pannedView;
- (void)pannedViewTapped:(WCPannedView *)pannedView;
@end

@interface WCPannedView : UIView

/// Use the contentView to add subview. Don't use WCPannedView itself
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, strong, readonly) UIView *backgroundView;
/// Default: 1.5. Set 0 to disable the scale effect.
@property (nonatomic, assign) CGFloat scaleFactorWhenHolding;
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong, readonly) UITapGestureRecognizer *tapGesture;
@property (nonatomic, weak) id<WCPannedViewDelegate> delegate;

- (void)addToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
