//
//  ShapeBaseViewController.h
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

#define DEBUG_SHOW_LAYER_BORDER 1

#if DEBUG_SHOW_LAYER_BORDER
#define SHOW_LAYER_BORDER(layer) \
(layer).borderWidth = 1.0; \
(layer).borderColor = [UIColor blueColor].CGColor;
#else
#define SHOW_LAYER_BORDER(layer)
#endif

@interface ShapeBaseViewController : UIViewController
@property (nonatomic, strong, readonly) UIView *contentView;
@end

NS_ASSUME_NONNULL_END
