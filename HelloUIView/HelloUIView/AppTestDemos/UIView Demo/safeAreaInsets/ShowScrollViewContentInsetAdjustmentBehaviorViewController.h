//
//  ShowScrollViewContentInsetAdjustmentBehaviorViewController.h
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WCScrollViewTool.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, ScrollAxisType) {
    ScrollAxisTypeVertical,
    ScrollAxisTypeHorizontal,
    ScrollAxisTypeAll,
};

@interface ShowScrollViewContentInsetAdjustmentBehaviorViewController : UIViewController
@property (nonatomic, assign) ScrollAxisType scrollAxisType;
@property (nonatomic, assign) WCScrollViewContentInsetAdjustmentBehavior behavior;
@end

NS_ASSUME_NONNULL_END
