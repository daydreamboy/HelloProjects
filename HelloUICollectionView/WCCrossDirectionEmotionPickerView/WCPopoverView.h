//
//  WCPopoverView.h
//  
//
//  Created by wesley chen on 2017/6/14.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCPopoverViewShowMode) {
    WCPopoverViewShowModeOnDefaultWindow,
    WCPopoverViewShowModeOnNewWindow,
    WCPopoverViewShowModeOnCustomView,
};

@interface WCPopoverViewDescriptor : NSObject
@property (nonatomic, assign) WCPopoverViewShowMode showMode;
#pragma mark > arrow
@property (nonatomic, assign) CGFloat arrowWidth;
@property (nonatomic, assign) CGFloat arrowHeight;
#pragma mark > box layout
@property (nonatomic, assign) CGFloat boxPadding;
@property (nonatomic, assign) CGFloat boxCornerRadius;
#pragma mark > box border
@property (nonatomic, strong, nullable) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
#pragma mark > box shadow
@property (nonatomic, assign) CGFloat boxShadowBlurRadius;
@property (nonatomic, strong, nullable) UIColor *boxShadowBlurColor;
@property (nonatomic, assign) CGSize boxShadowOffset;
#pragma mark > box gradient
@property (nonatomic, strong, nullable) NSArray<UIColor *> *boxGradientColors;
@property (nonatomic, strong, nullable) NSArray<NSNumber *> *boxGradientLocations;
@property (nonatomic, assign) CGPoint boxGradientStartPoint;
@property (nonatomic, assign) CGPoint boxGradientEndPoint;
#pragma mark > interact
@property (nonatomic, assign) BOOL autoDismissWhenTapOutside;
@property (nonatomic, assign) CGFloat autoDismissAfterSeconds; // <=0 for never auto dismiss
@property (nonatomic, assign) CGFloat showDuration;
@property (nonatomic, assign) CGFloat dismissDuration;
@end

@interface WCPopoverView : UIView

+ (WCPopoverView *)showPopoverViewAtPoint:(CGPoint)point inView:(UIView *)view contentView:(UIView *)contentView;
+ (WCPopoverView *)showPopoverViewAtPoint:(CGPoint)point inView:(UIView *)view contentView:(UIView *)contentView descriptor:(WCPopoverViewDescriptor *)descriptor;

+ (WCPopoverView *)showPopoverViewRelativeToView:(UIView *)view locationInView:(CGPoint)locationInView contentView:(UIView *)contentView descriptor:(WCPopoverViewDescriptor *)descriptor;

- (void)dismiss:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
