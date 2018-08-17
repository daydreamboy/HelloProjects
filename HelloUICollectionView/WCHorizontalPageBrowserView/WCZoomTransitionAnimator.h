//
//  WCZoomTransitionAnimator.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/8/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCZoomTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>
@property (nonatomic, assign, readonly) CGRect fromRect;
- (instancetype)initWithFromRect:(CGRect)fromRect;
@end

