//
//  GroupSubviewsByRelayoutSubviewsViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/4/24.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "GroupSubviewsByRelayoutSubviewsViewController.h"
#import "WCViewTool.h"
#import "UIView+Position.h"

@interface GroupSubviewsByRelayoutSubviewsViewController ()
@property (nonatomic, strong) UIView *containerView1;
@property (nonatomic, strong) UIView *containerView2;
@end

@implementation GroupSubviewsByRelayoutSubviewsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self layoutSubviews];
    [self layoutSubviewsCenteredInViewController];
}

#pragma mark - Getters

- (void)layoutSubviews {
    UIView *subview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    subview1.backgroundColor = [UIColor redColor];
    [self.view addSubview:subview1];
    
    UIView *subview2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview1.frame) + 10, 50, 50)];
    subview2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:subview2];
}

- (void)layoutSubviewsCenteredInViewController {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIView *containerView = [UIView new];
    containerView.layer.borderColor = [UIColor purpleColor].CGColor;
    containerView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    
    UIView *subview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    subview1.backgroundColor = [UIColor redColor];
    [self.view addSubview:subview1];
    
    UIView *subview2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(subview1.frame) + 10, 50, 50)];
    subview2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:subview2];
    
    UIView *subview3 = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(subview2.frame), CGRectGetMaxY(subview2.frame) + 10, 100, 100)];
    subview3.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:subview3];
    
    NSMutableArray *subviewsToRelayout = [NSMutableArray array];
    [subviewsToRelayout addObject:subview1];
    [subviewsToRelayout addObject:subview2];
    
    CGRect groupRect = CGRectZero;
    [WCViewTool makeSubviewsIntoGroup:subviewsToRelayout centeredAtPoint:CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0) groupViewsRect:&groupRect];
    
    containerView.frame = groupRect;
    [self.view addSubview:containerView];
}

@end
