//
//  WCPannedView.h
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/7/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCPannedView : UIView

/// Use the contentView to add subview. Don't use WCPannedView itself
@property (nonatomic, strong, readonly) UIView *contentView;
/// Default: 1.5. Set 0 to disable the scale effect.
@property (nonatomic, assign) CGFloat scaleFactorWhenHolding;

- (void)addToView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
