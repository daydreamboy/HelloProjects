//
//  WCKeyboardObserver.h
//  HelloUITextView
//
//  Created by wesley_chen on 2020/8/31.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#if defined(__has_attribute) && __has_attribute(objc_subclassing_restricted)
#define WC_RESTRICT_SUBCLASSING __attribute__((objc_subclassing_restricted))
#else
#define WC_RESTRICT_SUBCLASSING
#endif

typedef void (^WCKeyboardObserverKeyboardWillAnimate)(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isToShow);
typedef void (^WCKeyboardObserverKeyboardInAnimate)(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isToShow);
typedef void (^WCKeyboardObserverKeyboardDidAnimate)(BOOL finished, BOOL isToShow);

typedef void (^WCKeyboardObserverKeyboardWillChangeFrame)(CGRect keyboardRectEnd, NSTimeInterval duration);
typedef void (^WCKeyboardObserverKeyboardInChangeFrame)(CGRect keyboardRectEnd, NSTimeInterval duration);
typedef void (^WCKeyboardObserverKeyboardDidChangeFrame)(BOOL finished);

WC_RESTRICT_SUBCLASSING
@interface WCKeyboardObserver : NSObject

// Keyboard show or hide
@property (nonatomic, copy) WCKeyboardObserverKeyboardWillAnimate willAnimateBlock;
@property (nonatomic, copy) WCKeyboardObserverKeyboardInAnimate inAnimateBlock;
@property (nonatomic, copy) WCKeyboardObserverKeyboardDidAnimate didAnimateBlock;

// Keyboard change frame
@property (nonatomic, copy) WCKeyboardObserverKeyboardWillChangeFrame willChangeFrameBlock;
@property (nonatomic, copy) WCKeyboardObserverKeyboardInChangeFrame inChangeFrameBlock;
@property (nonatomic, copy) WCKeyboardObserverKeyboardDidChangeFrame didChangeFrameBlock;

- (instancetype)initWithObservee:(nullable id)observee;

- (void)registerObserverWithKeyboardWillAnimate:(nullable WCKeyboardObserverKeyboardWillAnimate)willAnimate inAnimate:(nullable WCKeyboardObserverKeyboardInAnimate)inAnimate didAnimate:(nullable WCKeyboardObserverKeyboardDidAnimate)didAnimate;

- (void)registerObserverWithKeyboardWillChangeFrame:(nullable WCKeyboardObserverKeyboardWillChangeFrame)willChangeFrame inChangeFrame:(nullable WCKeyboardObserverKeyboardInChangeFrame)inChangeFrame didChangeFrame:(nullable WCKeyboardObserverKeyboardDidChangeFrame)didChangeFrame;

@end

NS_ASSUME_NONNULL_END
