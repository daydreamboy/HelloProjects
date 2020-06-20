//
//  AnimationBaseViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 2020/6/20.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "AnimationBaseViewController.h"
#import "WCMacroTool.h"

@interface AnimationBaseViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong, readwrite) UIView *contentView;
@end

@implementation AnimationBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.scrollView.frame = self.view.bounds;
    
    UIView *lastAddedView = [[self.contentView subviews] lastObject];
    self.contentView.frame = FrameSetSize(self.contentView.frame, NAN, CGRectGetMaxY(lastAddedView.frame));
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.contentView.bounds), CGRectGetHeight(self.contentView.bounds));
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        
        _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 0)];
        [scrollView addSubview:_contentView];
        scrollView.contentSize = CGSizeMake(CGRectGetWidth(_contentView.bounds), CGRectGetHeight(_contentView.bounds));
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

@end