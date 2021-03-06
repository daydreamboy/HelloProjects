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

//#define ContentHeight 900 // 200

@interface PullRefreshViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
//@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) UILabel *hudTip;
@property (nonatomic, assign) UIGestureRecognizerState state;
@end

@implementation PullRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Configure: toggle animate and set content height
    //self.contentHeight = ContentHeight;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.hudTip];
    
    UIBarButtonItem *verticalItem = [[UIBarButtonItem alloc] initWithTitle:@"Vertical" style:UIBarButtonItemStylePlain target:self action:@selector(verticalItemClicked:)];
    UIBarButtonItem *horizontalItem = [[UIBarButtonItem alloc] initWithTitle:@"Horizontal" style:UIBarButtonItemStylePlain target:self action:@selector(horizontalItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[horizontalItem, verticalItem];
    
    weakify(self);
    [WCScrollViewTool observeTouchEventWithScrollView:self.scrollView touchEventCallback:^(UIScrollView *scrollView, UIGestureRecognizerState state) {
        strongifyWithReturn(self, return);
        
        if (self.scrollView == scrollView) {
            if (state == UIGestureRecognizerStateBegan) {
                self.state = state;
                
                CGSize screenSize = [[UIScreen mainScreen] bounds].size;
                self.hudTip.alpha = 1;
                self.hudTip.text = @"User begin dragging";
                [self.hudTip sizeToFit];
                self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
            }
            else if (state == UIGestureRecognizerStateEnded || state == UIGestureRecognizerStateCancelled) {
                self.state = state;
                
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
    
    [WCScrollViewTool observeScrollingEventWithScrollView:self.scrollView scrollingEventCallback:^(UIScrollView * _Nonnull scrollView) {
        if (self.state == UIGestureRecognizerStateEnded || self.state == UIGestureRecognizerStateCancelled) {
            return ;
        }
        
        if ([WCScrollViewTool checkIsScrollingOverTopWithScrollView:scrollView]) {
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            self.hudTip.alpha = 1;
            self.hudTip.text = @"scrolling over top";
            [self.hudTip sizeToFit];
            self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        }
        else if ([WCScrollViewTool checkIsScrollingOverBottomWithScrollView:scrollView]) {
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            self.hudTip.alpha = 1;
            self.hudTip.text = @"scrolling over bottom";
            [self.hudTip sizeToFit];
            self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        }
        else if ([WCScrollViewTool checkIsScrollingOverLeftWithScrollView:scrollView]) {
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            self.hudTip.alpha = 1;
            self.hudTip.text = @"scrolling over left";
            [self.hudTip sizeToFit];
            self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        }
        else if ([WCScrollViewTool checkIsScrollingOverRightWithScrollView:scrollView]) {
            CGSize screenSize = [[UIScreen mainScreen] bounds].size;
            self.hudTip.alpha = 1;
            self.hudTip.text = @"scrolling over right";
            [self.hudTip sizeToFit];
            self.hudTip.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
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
        
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, screenSize.height - startY)];
        scrollView.contentInset = UIEdgeInsetsMake(topInset, 10, bottomInset, 10);
        scrollView.backgroundColor = [UIColor yellowColor];
        
        CGSize contentSize = [WCScrollViewTool fittedContentSizeWithScrollView:scrollView];
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentSize.width, contentSize.height * 2)];
        contentView.backgroundColor = [UIColor greenColor];
        
        scrollView.contentSize = contentView.bounds.size;
        [scrollView addSubview:contentView];
        
        _scrollView = scrollView;
        _contentView = contentView;
    }
    
    return _scrollView;
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

#pragma mark - Actions

- (void)verticalItemClicked:(id)sender {
    CGSize contentSize = [WCScrollViewTool fittedContentSizeWithScrollView:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(contentSize.width, contentSize.height * 2);
    self.contentView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

- (void)horizontalItemClicked:(id)sender {
    CGSize contentSize = [WCScrollViewTool fittedContentSizeWithScrollView:self.scrollView];
    self.scrollView.contentSize = CGSizeMake(contentSize.width * 2, contentSize.height);
    self.contentView.frame = CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

@end
