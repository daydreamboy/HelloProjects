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
    [WCScrollViewTool observeTouchEventWithScrollView:self.scrollView eventCallback:^(UIScrollView *scrollView, UIGestureRecognizerState state) {
        
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
//    [self.scrollView.panGestureRecognizer removeObserver:self forKeyPath:@"state"];
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

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"state"]) {
        if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
            NSLog(@"Began");
        }
        else if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
            NSLog(@"Ended");
        }
        else if (self.scrollView.panGestureRecognizer.state == UIGestureRecognizerStateCancelled) {
            NSLog(@"Cancelled");
        }
    }
}

@end
