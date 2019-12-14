//
//  ScrollToEdgesViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2018/5/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ScrollToEdgesViewController.h"
#import "WCScrollViewTool.h"
#import "WCViewTool.h"
#import "ContentView.h"

#define ContentHeight 900 // 200

@interface ScrollToEdgesViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) ContentView *contentView;
@property (nonatomic, assign) BOOL scrollAnimated;
@property (nonatomic, assign) CGFloat contentHeight;
//@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIView *toolbarView;
@end

@implementation ScrollToEdgesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;

    // Configure: toggle animate and set content height
    self.scrollAnimated = YES;
    self.contentHeight = ContentHeight;

    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.toolbarView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.scrollView.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);
    
    self.toolbarView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
}

#pragma mark - Getters

- (ContentView *)contentView {
    if (!_contentView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        ContentView *contentView = [[ContentView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width * 2.5, screenSize.height * 2.5)];
        contentView.backgroundColor = [UIColor greenColor];
        
//        UILabel *labelAtTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 30)];
//        labelAtTop.text = @"top";
//        labelAtTop.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
//        labelAtTop.textAlignment = NSTextAlignmentCenter;
//        [contentView addSubview:labelAtTop];
//
//        UILabel *labelAtBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, contentHeight - 30, screenSize.width, 30)];
//        labelAtBottom.text = @"bottom";
//        labelAtBottom.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
//        labelAtBottom.textAlignment = NSTextAlignmentCenter;
//        [contentView addSubview:labelAtBottom];
        
        _contentView = contentView;
    }
    
    return _contentView;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
        scrollView.contentInset = UIEdgeInsetsMake(10, 20, 30, 40);
        scrollView.backgroundColor = [UIColor yellowColor];
        scrollView.contentSize = self.contentView.bounds.size;
        [scrollView addSubview:self.contentView];
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

- (UIView *)toolbarView {
    if (!_toolbarView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIBarButtonItem *itemBack = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(itemBackClicked:)];
        
        UIBarButtonItem *itemScrollToTop = [[UIBarButtonItem alloc] initWithTitle:@"ScrollView⬆️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToTopClicked:)];
        
        UIBarButtonItem *itemScrollToLeft = [[UIBarButtonItem alloc] initWithTitle:@"ScrollView⬅️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToLeftClicked:)];
        
        UIBarButtonItem *itemScrollToBottom = [[UIBarButtonItem alloc] initWithTitle:@"ScrollView⬇️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToBottomClicked:)];

        UIBarButtonItem *itemScrollToRight = [[UIBarButtonItem alloc] initWithTitle:@"ScrollView➡️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToRightClicked:)];
        
        UIBarButtonItem *itemScrollToTopOfContent = [[UIBarButtonItem alloc] initWithTitle:@"Content⬆️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToTopOfContentClicked:)];
        
        UIBarButtonItem *itemScrollToLeftOfContent = [[UIBarButtonItem alloc] initWithTitle:@"Content⬅️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToLeftOfContentClicked:)];
        
        UIBarButtonItem *itemScrollToBottomOfContent = [[UIBarButtonItem alloc] initWithTitle:@"Content⬇️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToBottomOfContentClicked:)];
        
        UIBarButtonItem *itemScrollToRightOfContent = [[UIBarButtonItem alloc] initWithTitle:@"Content➡️" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToRightOfContentClicked:)];
        
        NSArray *items1 = @[itemBack];
        
        NSArray *items2 = @[
                           itemScrollToTop,
                           itemScrollToLeft,
                           itemScrollToBottom,
                           itemScrollToRight
                        ];
        
        NSArray *items3 = @[
                           itemScrollToTopOfContent,
                           itemScrollToLeftOfContent,
                           itemScrollToBottomOfContent,
                           itemScrollToRightOfContent
                        ];
        
        NSMutableArray *allItems = [NSMutableArray array];
        [allItems addObject:items1];
        [allItems addObject:items2];
        [allItems addObject:items3];
        
        // @see https://stackoverflow.com/a/17091443
        for (UIBarItem *barItem in [allItems valueForKeyPath:@"@unionOfArrays.self"]) {
            [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateNormal];
            [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]} forState:UIControlStateHighlighted];
        }
        
        UIView *containerView = [[UIView alloc] initWithFrame:CGRectZero];
        
        CGFloat startY = 0;
        for (NSInteger i = 0; i < allItems.count; i++) {
            UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, startY, 440, 44)];
            [toolbar setShadowImage:[UIImage new] forToolbarPosition:UIBarPositionAny];
            [toolbar setItems:allItems[i] animated:NO];
            // Note: not work as expect to fit all items, only fit to screen.width and 44
            //[toolbar sizeToFit];
            
            startY = CGRectGetMaxY(toolbar.frame);
            
            [containerView addSubview:toolbar];
        }
        
        [WCViewTool makeViewFrameToFitAllSubviewsWithSuperView:containerView];
        
        containerView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(viewPanned:)];
        [containerView addGestureRecognizer:panGesture];
        
        _toolbarView = containerView;
    }
    
    return _toolbarView;
}

#pragma mark - Actions

- (void)itemBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Scroll to edges of ScrollView

- (void)itemScrollToBottomClicked:(id)sender {
    [WCScrollViewTool scrollToBottomWithScrollView:self.scrollView animated:self.scrollAnimated];
}

- (void)itemScrollToTopClicked:(id)sender {
    [WCScrollViewTool scrollToTopWithScrollView:self.scrollView animated:self.scrollAnimated];
}

- (void)itemScrollToLeftClicked:(id)sender {
    [WCScrollViewTool scrollToLeftWithScrollView:self.scrollView animated:self.scrollAnimated];
}

- (void)itemScrollToRightClicked:(id)sender {
    [WCScrollViewTool scrollToRightWithScrollView:self.scrollView animated:self.scrollAnimated];
}

#pragma mark - Scroll to edges of Content

- (void)itemScrollToBottomOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToBottomOfContentWithScrollView:self.scrollView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToTopOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToTopOfContentWithScrollView:self.scrollView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToLeftOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToLeftOfContentWithScrollView:self.scrollView animated:self.scrollAnimated considerSafeArea:YES];
}

- (void)itemScrollToRightOfContentClicked:(id)sender {
    [WCScrollViewTool scrollToRightOfContentWithScrollView:self.scrollView animated:self.scrollAnimated considerSafeArea:YES];
}

#pragma mark - 

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
