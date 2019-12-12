//
//  ScrollToTopOrBottomViewController.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2018/5/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ScrollToTopOrBottomViewController.h"

#define ContentHeight 900 // 200

@interface ScrollToTopOrBottomViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) BOOL scrollAnimated;
@property (nonatomic, assign) CGFloat contentHeight;
@end

@implementation ScrollToTopOrBottomViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Configure: toggle animate and set content height
    self.scrollAnimated = YES;
    self.contentHeight = ContentHeight;

    [self.view addSubview:self.scrollView];
    
    UIBarButtonItem *itemScrollToBottom = [[UIBarButtonItem alloc] initWithTitle:@"UIScrollView底部" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToBottomClicked:)];

    UIBarButtonItem *itemScrollToTop = [[UIBarButtonItem alloc] initWithTitle:@"UIScrollView顶部" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToTopClicked:)];
    
    UIBarButtonItem *itemScrollToBottomOfContent = [[UIBarButtonItem alloc] initWithTitle:@"内容底部" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToBottomOfContentClicked:)];
    
    UIBarButtonItem *itemScrollToTopOfContent = [[UIBarButtonItem alloc] initWithTitle:@"内容顶部" style:UIBarButtonItemStylePlain target:self action:@selector(itemScrollToTopOfContentClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[itemScrollToBottom, itemScrollToTop, itemScrollToBottomOfContent, itemScrollToTopOfContent];
    
    for (UIBarItem *barItem in self.navigationItem.rightBarButtonItems) {
        [barItem setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:10]} forState:UIControlStateNormal];
    }
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
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, screenSize.width, screenSize.height - 100 - 20)];
        scrollView.contentInset = UIEdgeInsetsMake(topInset, 0, bottomInset, 0);
        scrollView.backgroundColor = [UIColor yellowColor];
        scrollView.contentSize = self.contentView.bounds.size;
        [scrollView addSubview:self.contentView];
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

#pragma mark - Actions

- (void)itemScrollToBottomOfContentClicked:(id)sender {
    CGPoint bottomOffset = CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height);
    [_scrollView setContentOffset:bottomOffset animated:self.scrollAnimated];
}

- (void)itemScrollToTopOfContentClicked:(id)sender {
    CGPoint topOffset = CGPointMake(0, 0);
    [_scrollView setContentOffset:topOffset animated:self.scrollAnimated];
}

- (void)itemScrollToBottomClicked:(id)sender {
    // @see https://stackoverflow.com/a/38241928
    CGPoint bottomOffset = CGPointMake(0, _scrollView.contentSize.height - _scrollView.bounds.size.height + _scrollView.contentInset.bottom);
    [_scrollView setContentOffset:bottomOffset animated:self.scrollAnimated];
}

- (void)itemScrollToTopClicked:(id)sender {
    CGPoint topOffset = CGPointMake(0, -_scrollView.contentInset.top);
    [_scrollView setContentOffset:topOffset animated:self.scrollAnimated];
}

@end
