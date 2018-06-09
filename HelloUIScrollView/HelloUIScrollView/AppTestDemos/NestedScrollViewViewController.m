//
//  NestedScrollViewViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2018/6/9.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NestedScrollViewViewController.h"

@interface NestedScrollViewViewController () <UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollViewParent;
@property (nonatomic, strong) UIScrollView *scrollViewChild;
@end

@implementation NestedScrollViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.scrollViewParent];
}

#define ScrollViewHeight 200

#pragma mark - Getters

- (UIScrollView *)scrollViewParent {
    if (!_scrollViewParent) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, screenSize.width, ScrollViewHeight)];
        scrollView.backgroundColor = [UIColor yellowColor];
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.contentSize = CGSizeMake(1000, ScrollViewHeight);
        
        [scrollView addSubview:self.scrollViewChild];
        
        _scrollViewParent = scrollView;
    }
    
    return _scrollViewParent;
}

- (UIScrollView *)scrollViewChild {
    if (!_scrollViewChild) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, ScrollViewHeight)];
        scrollView.backgroundColor = [UIColor greenColor];
        scrollView.alwaysBounceHorizontal = YES;
        scrollView.delegate = self;
        scrollView.contentSize = CGSizeMake(600, ScrollViewHeight);
        
        _scrollViewChild = scrollView;
    }
    
    return _scrollViewChild;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // FIXME: 设置enabled=NO不能保证滑动连贯性，即scrollViewChild滑动到最右边，然后让scrollViewParent接着滑动。
    if (scrollView == self.scrollViewChild) {
        if (scrollView.contentOffset.x <= 0) {
            scrollView.panGestureRecognizer.enabled = NO;
        }
        else if (scrollView.contentOffset.x >= scrollView.contentSize.width - scrollView.bounds.size.width) {
            scrollView.panGestureRecognizer.enabled = NO;
        }
    }
}

@end
