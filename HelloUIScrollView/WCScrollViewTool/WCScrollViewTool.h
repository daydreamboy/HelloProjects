//
//  WCScrollViewTool.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/9/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCScrollViewTool : NSObject

/**
 Observe the user touch event on the scroll view
 
 @param scrollView the scroll view
 @param eventCallback the callback when event happened.
 - scrollView The touching scroll view
 - state The state of eventCallback is same as UIGestureRecognizerState.
 @return YES if setup the observing successfully, NO if the parameters are wrong or already setup once
 @discussion The eventCallback should not retain the scroll view again, use its the first parameter instead
 */
+ (BOOL)observeTouchEventWithScrollView:(UIScrollView *)scrollView eventCallback:(void (^)(UIScrollView *scrollView, UIGestureRecognizerState state))eventCallback;

@end

NS_ASSUME_NONNULL_END
