//
//  WCGenieAnimation.h
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/15.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCGenieAnimationRectEdge) {
    WCGenieAnimationRectEdgeTop = 0,
    WCGenieAnimationRectEdgeLeft = 1,
    WCGenieAnimationRectEdgeBottom = 2,
    WCGenieAnimationRectEdgeRight = 3,
};

@interface WCGenieAnimation : NSObject

+ (BOOL)genieInTransitionWithView:(UIView *)view duration:(NSTimeInterval)duration destinationRect:(CGRect)destinationRect destinationEdge:(WCGenieAnimationRectEdge)destEdge completion:(void (^)(void))completion;

+ (BOOL)genieOutTransitionWithView:(UIView *)view duration:(NSTimeInterval)duration startRect:(CGRect)startRect startEdge:(WCGenieAnimationRectEdge)startEdge completion:(void (^)(void))completion;

@end

NS_ASSUME_NONNULL_END
