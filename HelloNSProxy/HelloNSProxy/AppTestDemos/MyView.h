//
//  MyView.h
//  HelloNSProxy
//
//  Created by wesley_chen on 2018/5/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyView;

@protocol MyViewLifeCycle
- (void)myViewWillAppear:(MyView *)myView;
- (void)myViewDidAppear:(MyView *)myView;
- (void)myViewWillDisappear:(MyView *)myView;
- (void)myViewDidDisappear:(MyView *)myView;
@end

@interface MyView : UIView
@property (nonatomic, weak) id<MyViewLifeCycle> delegate;
@end
