//
//  PullRefreshViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/11/6.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "PullRefreshViewController.h"
#import "WCScrollViewTool.h"

@interface PullRefreshViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@end

@implementation PullRefreshViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    __weak typeof(self) weak_self = self;
    [WCScrollViewTool observeTouchEventWithScrollView:self.scrollView touchEventCallback:^(UIScrollView *scrollView, UIGestureRecognizerState state) {
        
        if (weak_self.scrollView == scrollView) {
            if (state == UIGestureRecognizerStateBegan) {
                NSLog(@"Began");
            }
            else if (state == UIGestureRecognizerStateEnded) {
                NSLog(@"Ended");
            }
            else if (state == UIGestureRecognizerStateCancelled) {
                NSLog(@"Cancelled");
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
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.backgroundColor = [UIColor yellowColor];
        scrollView.contentSize = CGSizeMake(screenSize.width, screenSize.height * 2);
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

@end
