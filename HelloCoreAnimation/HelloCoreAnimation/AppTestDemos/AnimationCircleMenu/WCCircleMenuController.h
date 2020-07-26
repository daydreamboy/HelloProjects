//
//  WCCircleMenuController.h
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/7/26.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCCircleMenuController : NSObject

@property (nonatomic, assign) CGFloat menuEntrySide;

- (BOOL)addCircleMenuToView:(UIView *)view atPoint:(CGPoint)center;

@end

NS_ASSUME_NONNULL_END
