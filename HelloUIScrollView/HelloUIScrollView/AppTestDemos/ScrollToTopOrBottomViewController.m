//
//  ScrollToTopOrBottomViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2018/5/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ScrollToTopOrBottomViewController.h"
#import "WCScrollViewTool.h"

#define ContentHeight 900 // 200

@interface ScrollToTopOrBottomViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL scrollAnimated;
@property (nonatomic, assign) CGFloat contentHeight;
@property (nonatomic, strong) UIToolbar *toolbar;
@end

@implementation ScrollToTopOrBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;

    // Configure: toggle animate and set content height
    self.scrollAnimated = YES;
    self.contentHeight = ContentHeight;

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

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat topInset = 100;
        CGFloat bottomInset = 100;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
        scrollView.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
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
        
        UIBarButtonItem *itemScrollToBottom = [[UIBarButtonItem alloc] initWithTitle:@"UIScrollView底部" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToBottomClicked:)];

        UIBarButtonItem *itemScrollToTop = [[UIBarButtonItem alloc] initWithTitle:@"UIScrollView顶部" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToTopClicked:)];
        
        UIBarButtonItem *itemScrollToBottomOfContent = [[UIBarButtonItem alloc] initWithTitle:@"内容底部" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToBottomOfContentClicked:)];
        
        UIBarButtonItem *itemScrollToTopOfContent = [[UIBarButtonItem alloc] initWithTitle:@"内容顶部" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToTopOfContentClicked:)];
        
        NSArray *items = @[itemBack, itemScrollToBottom, itemScrollToTop, itemScrollToBottomOfContent, itemScrollToTopOfContent];
        
        for (UIBarItem *barItem in items) {
            [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
            [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateHighlighted];
        }
        
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 500, 44)];
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

- (void)itemScrollToBottomOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToBottomOfContentWithScrollView:self.scrollView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToTopOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToTopOfContentWithScrollView:self.scrollView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToBottomClicked:(id)sender {
    [WCScrollViewTool scrollToBottomWithScrollView:self.scrollView animated:self.scrollAnimated];
}

- (void)itemScrollToTopClicked:(id)sender {
    [WCScrollViewTool scrollToTopWithScrollView:self.scrollView animated:self.scrollAnimated];
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
