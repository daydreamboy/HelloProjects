//
//  WCMessageComposerView.h
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCMessageInputItem.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^WCMessageComposerViewKeyboardWillAnimateBlock)(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isToShow);
typedef void(^WCMessageComposerViewKeyboardInAnimateBlock)(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isToShow);
typedef void(^WCMessageComposerViewKeyboardDidAnimateBlock)(BOOL finished, BOOL isToShow);

/**
 
 */
@interface WCMessageComposerView : UIView

// Self
@property (nonatomic, assign) UIEdgeInsets contentInsets;

// Text Input
@property (nonatomic, assign) UIEdgeInsets textInputAreaMargins;
@property (nonatomic, assign) UIEdgeInsets textInputAreaInsets;
@property (nonatomic, assign) CGFloat textInputAreaMinimumHeight;
@property (nonatomic, assign) CGFloat textInputAreaCornerRadius;
@property (nonatomic, strong) UIFont *textFont;

// Items
@property (nonatomic, assign) CGFloat spaceBetweenOutterItems;
@property (nonatomic, assign) CGFloat spaceBetweenInnerItems;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)addMessageInputItem:(WCMessageInputItem *)item;

- (void)setupBottomAutoLayoutWithViewController:(UIViewController *)viewController keyboardWillAnimate:(nullable WCMessageComposerViewKeyboardWillAnimateBlock)keyboardWillAnimate keyboardInAnimate:(nullable WCMessageComposerViewKeyboardInAnimateBlock)keyboardInAnimate keyboardDidAnimate:(nullable WCMessageComposerViewKeyboardDidAnimateBlock)keyboardDidAnimate;

@end

NS_ASSUME_NONNULL_END
