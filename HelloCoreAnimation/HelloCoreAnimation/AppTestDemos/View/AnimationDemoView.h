//
//  AnimationDemoView.h
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/20.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AnimationDemoView : UIView
@property (nonatomic, strong) void (^doAnimation)(void);
@end

NS_ASSUME_NONNULL_END
