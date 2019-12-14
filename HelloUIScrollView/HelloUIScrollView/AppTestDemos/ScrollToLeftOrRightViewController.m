//
//  ScrollToLeftOrRightViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/12/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "ScrollToLeftOrRightViewController.h"
#import "WCScrollViewTool.h"

#define ContentWidth 900 // 200

@interface ScrollToLeftOrRightViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL scrollAnimated;
@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, strong) UIToolbar *toolbar;
@end

@implementation ScrollToLeftOrRightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;

    // Configure: toggle animate and set content height
    self.scrollAnimated = YES;
    self.contentWidth = ContentWidth;

    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.toolbar];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    self.toolbar.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
}

#pragma mark - Getters

- (UIView *)contentView {
    if (!_contentView) {
        CGFloat contentWidth = self.contentWidth;
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, 300)];
        contentView.backgroundColor = [UIColor greenColor];
        
        UILabel *labelAtLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, screenSize.height)];
        labelAtLeft.text = @"left";
        labelAtLeft.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        labelAtLeft.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:labelAtLeft];
        
        UILabel *labelAtRight = [[UILabel alloc] initWithFrame:CGRectMake(contentWidth - 40, 0, 40, screenSize.height)];
        labelAtRight.text = @"right";
        labelAtRight.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        labelAtRight.textAlignment = NSTextAlignmentCenter;
        [contentView addSubview:labelAtRight];
        
        _contentView = contentView;
    }
    
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat leftInset = 30;
        CGFloat rightInset = 50;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
        scrollView.contentInset = UIEdgeInsetsMake(0 , leftInset, 0, rightInset);
        scrollView.backgroundColor = [UIColor yellowColor];
        scrollView.contentSize = self.contentView.bounds.size;
        [scrollView addSubview:self.contentView];
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

- (UIToolbar *)toolbar {
    if (!_toolbar) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(itemBackClicked:)];
        
        UIBarButtonItem *itemScrollToLeft = [[UIBarButtonItem alloc] initWithTitle:@"UIScrollView左边" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToLeftClicked:)];

        UIBarButtonItem *itemScrollToRight = [[UIBarButtonItem alloc] initWithTitle:@"UIScrollView右边" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToRightClicked:)];
        
        UIBarButtonItem *itemScrollToLeftOfContent = [[UIBarButtonItem alloc] initWithTitle:@"内容左边" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToLeftOfContentClicked:)];
        
        UIBarButtonItem *itemScrollToRightOfContent = [[UIBarButtonItem alloc] initWithTitle:@"内容右边" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToRightOfContentClicked:)];
        
        NSArray *items = @[itemBack, itemScrollToLeft, itemScrollToRight, itemScrollToLeftOfContent, itemScrollToRightOfContent];
        
        for (UIBarItem *barItem in items) {
            [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
            [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateHighlighted];
        }
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 400, 44)];
        [toolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
        [toolbar setItems:items animated:NO];
        // Note: not work as expect to fit all items, only fit to screen.width and 44
        //[toolbar sizeToFit];
        
        toolbar.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
        [toolbar addGestureRecognizer:panGesture];
        
        _toolbar = toolbar;
    }
    
    return _toolbar;
}

#pragma mark - Actions

- (void)itemBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)itemScrollToLeftOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToLeftOfContentWithScrollView:self.scrollView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToRightOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToRightOfContentWithScrollView:self.scrollView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToLeftClicked:(id)sender {
    [WCScrollViewTool scrollToLeftWithScrollView:self.scrollView animated:self.scrollAnimated];
}

- (void)itemScrollToRightClicked:(id)sender {
    [WCScrollViewTool scrollToRightWithScrollView:self.scrollView animated:self.scrollAnimated];
}

- (void)viewPanned:(UIPanGestureRecognizer *)recognizer {
    // @see https://stackoverflow.com/questions/25503537/swift-uigesturerecogniser-follow-finger
    UIView *targetView = recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan || recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [recognizer translationInView:self.view];
        targetView.center = CGPointMake(targetView.center.x + translation.x, targetView.center.y + translation.y);
        // Note: reset translation when every UIGestureRecognizerStateChanged detected, so translation is always calculated based on CGPointZero
        [recognizer setTranslation:CGPointZero inView:self.view];
    }
}

@end
