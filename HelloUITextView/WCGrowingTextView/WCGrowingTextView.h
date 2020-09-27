//
//  WCGrowingTextView.h
//  HelloUITextView
//
//  Created by wesley_chen on 2020/8/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCPlaceholderTextView.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^heightChangeUserActionsBlockType)(CGFloat oldHeight, CGFloat newHeight);

@class WCGrowingTextView;

@protocol WCGrowingTextViewDelegate <UITextViewDelegate>

@optional

/**
 Tells the delegate that the growing text view will change height
 
 @param growingTextView the WCGrowingTextView object
 @param from CGFloat that identifies the start height of the growing text view.
 @param to CGFloat that identifies the end height of the growing text view.
 */
- (void)growingTextViewWillChangeHeight:(WCGrowingTextView *)growingTextView from:(CGFloat)from to:(CGFloat)to;

/**
 Tells the delegate that the growing text view did change height
 
 @param growingTextView  the WCGrowingTextView object
 @param from CGFloat that identifies the start height of the growing text view.
 @param to CGFloat that identifies the end height of the growing text view.
 */
- (void)growingTextViewDidChangeHeight:(WCGrowingTextView *)growingTextView from:(CGFloat)from to:(CGFloat)to;

@end

/**
 A light-weight UITextView subclass that automatically grows and shrinks based on the size of user input and can be constrained by maximum and minimum number of lines.
 */
@interface WCGrowingTextView : WCPlaceholderTextView
/**
 The maximum number of lines before enabling scrolling. The default value is `5`.
 */
@property (nonatomic, assign) int maximumNumberOfLines;
/**
 The minimum number of lines. The default value is `1`.
 */
@property (nonatomic, assign) int minimumNumberOfLines;
/**
 The current displayed number of lines. This value is calculated at run time.
 */
@property (nonatomic, assign, readonly) int numberOfLines;
/**
 The flag for use maximumHeight/minimumHeight instead of maximumNumberOfLines/minimumNumberOfLines
 
 Default is NO
 */
@property (nonatomic, assign) BOOL useHeightForNumberOfLines;
/**
 The maximum height including contentInsets
 */
@property (nonatomic, assign) CGFloat maximumHeight;
/**
 The minimum height including contentInsets
 
 @discussion the minimum height used for initial height. If text font (one line) height is greater than this
 minimumHeight, use the actual text height (including contentInsets)
 */
@property (nonatomic, assign) CGFloat minimumHeight;

/**
 The duration of the animation of the height change. The default value is `0.35`.
 */
@property (nonatomic, assign) double heightChangeAnimationDuration;
/**
 A Boolean value that determines whether the animation of the height change is enabled. Default value is `true`.
 */
@property (nonatomic, assign) BOOL enableHeightChangeAnimation;
/**
 The block which contains user defined actions that will run during the height change.
 */
@property (nonatomic, copy) heightChangeUserActionsBlockType heightChangeUserActionsBlock;
/**
 The receiver's delegate.
 */
@property (nonatomic, weak) id<WCGrowingTextViewDelegate> growingTextViewDelegate;

- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer;
- (CGFloat)currentHeight;

@end

NS_ASSUME_NONNULL_END
