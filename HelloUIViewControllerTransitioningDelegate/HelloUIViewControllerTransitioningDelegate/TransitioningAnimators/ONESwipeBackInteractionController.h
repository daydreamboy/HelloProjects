//
//  MLSSwipeBackInteractionController.h
//  Meilishuo
//
//  Created by wanghai on 14-9-23.
//  Copyright (c) 2014年 Meilishuo, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  手势delegate，用户手势划回过程的回调通知delegate
 */
@protocol ONEGestureBackInteractionDelegate <NSObject>

@optional
/**
 *  手势划回完成，当前页面即将关闭，要在此方法中执行页面退出前的清理代码。
 */
-(void)gestureBackFinish;

/**
 *  手势划回开始
 */
-(void)gestureBackBegin;
/**
 *  手势划回取消
 */
-(void)gestureBackCancel;
/**
 *  禁止手势返回
 *
 *  @return YES 禁止； NO 开启；
 */
-(BOOL)disableGuesture;

/**
 *  启动手势返回
 */
-(void)popActionForGesture;

@end

/**
 *  划回手势控制器
 */
@interface ONESwipeBackInteractionController : UIPercentDrivenInteractiveTransition

//@property(nonatomic,strong) ONEGestureTransitionBackContext *context;

/**
 *  进行初始设置
 *
 *  @param viewController 要支持手势划回的VC
 */
- (void)wireToViewController:(UIViewController*)viewController;

/**
 *  手势进行中：YES，正在进行手势交互；NO，未进行手势交互
 */
@property (nonatomic) BOOL interactionInProgress;

/**
 *  navigationcontroller 的手势返回
 */
//@property (nonatomic) BOOL forNavivationController;



-(void)setGestureBackInteractionDelegate:(id<ONEGestureBackInteractionDelegate>) gestureBackInteractionDelegate;

@end
