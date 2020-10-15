//
//  WCDragDownTransitionInteractor.h
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2020/10/15.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCDragDownTransitionInteractor : UIPercentDrivenInteractiveTransition

- (BOOL)enableInteractorOnView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
