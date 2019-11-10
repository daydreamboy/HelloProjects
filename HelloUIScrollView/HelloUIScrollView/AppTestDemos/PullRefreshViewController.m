//
//  PullRefreshViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/11/6.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "PullRefreshViewController.h"
#import "WCScrollViewTool.h"

#define weakify(object) \
__weak __typeof__(object) object##_weak_ = object;

#define strongify(object) \
__strong __typeof__(object) object = object##_weak_;

#define strongifyWithReturn(object, ...) \
__strong __typeof__(object) object = object##_weak_; \
if (!object) { \
    __VA_ARGS__; \
}

#define ContentHeight 900 // 200

@interface PullRefreshViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) UILabel *hudTip;
@end

@implementation PullRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure: toggle animate and set content height
    self.contentHeight = ContentHeight;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.hudTip];
    
    weakify(self);
    [WCScrollViewTool observeTouchEventWithScrollView:self.scrollView touchEventCallback:^(UIScrollView *scrollView, UIGestureRecognizerState state) {
        strongifyWithReturn(self, return);
        
        if (self.scrollView == scrollView) {
            if (state == UIGestureRecognizerStateBegan) {
                NSLog(@"Began");
                
                CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                self.hudTip.alpha = 1;
                self.hudTip.text = @"User begin dragging";
                [self.hudTip sizeToFit];
                self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
            }
            else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
                NSLog(@"Ended");
                
                CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                self.hudTip.alpha = 1;
                self.hudTip.text = @"User end dragging";
                [self.hudTip sizeToFit];
                self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
                [UIView animateWithDuration:1.5 animations:^{
                    self.hudTip.alpha = 0;
                }];
            }
        }
    }];
}

- (void)dealloc {
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat topInset = 100;
        CGFloat bottomInset = 100;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height - 64)];
        scrollView.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
        scrollView.backgroundColor = [UIColor yellowColor];
        scrollView.contentSize = self.contentView.bounds.size;
        [scrollView addSubview:self.contentView];
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

- (UIView *)contentView {
    if (!_contentView) {
        CGFloat contentHeight = self.contentHeight;
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, contentHeight)];
        contentView.backgroundColor = [UIColor greenColor];
        
        UILabel *labelAtTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 30)];
        labelAtTop.text = @"top";
        labelAtTop.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        labelAtTop.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:labelAtTop];
        
        UILabel *labelAtBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, contentHeight - 30, screenSize.width, 30)];
        labelAtBottom.text = @"bottom";
        labelAtBottom.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        labelAtBottom.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:labelAtBottom];
        
        _contentView = contentView;
    }
    
    return _contentView;
}

- (UILabel *)hudTip {
    if (!_hudTip) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.9];
        label.userInteractionEnabled = NO;
        label.layer.cornerRadius = 3;
        label.layer.masksToBounds = YES;
        label.alpha = 0;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:25];
        
        _hudTip = label;
    }
    
    return _hudTip;
}

@end
