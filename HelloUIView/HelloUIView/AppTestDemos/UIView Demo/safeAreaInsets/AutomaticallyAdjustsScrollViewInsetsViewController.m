//
//  AutomaticallyAdjustsScrollViewInsetsViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "AutomaticallyAdjustsScrollViewInsetsViewController.h"

@interface AutomaticallyAdjustsScrollViewInsetsViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation AutomaticallyAdjustsScrollViewInsetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:self.scrollView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.label.text = NSStringFromUIEdgeInsets(self.scrollView.contentInset);
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.startY, self.view.bounds.size.width, self.view.bounds.size.height)];
        scrollView.contentSize = CGSizeMake(screenSize.width, 2 * screenSize.height);
        scrollView.backgroundColor = [UIColor colorWithRed:157 / 255.0 green:254 / 255.0 blue:157 / 255.0 alpha:1];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, scrollView.contentSize.width, scrollView.contentSize.height)];
        view.backgroundColor = [UIColor orangeColor];
        [scrollView addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:scrollView.bounds];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
        _label = label;
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

#pragma mark - Action

- (void)viewTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
