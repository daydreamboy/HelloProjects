//
//  GroupSubviewsViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2018/9/18.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GroupSubviewsViewController.h"
#import "WCViewTool.h"
#import "UIView+Position.h"

@interface GroupSubviewsViewController ()
@property (nonatomic, strong) UIView *containerView1;
@property (nonatomic, strong) UIView *containerView2;
@end

@implementation GroupSubviewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.containerView1.y = 80;
    [self.view addSubview:self.containerView1];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.containerView2.y = screenSize.height / 2.0;
    [self.view addSubview:self.containerView2];
}

#pragma mark - Getters

- (UIView *)containerView1 {
    if (!_containerView1) {
        UIView *view = [UIView new];
        
        UIView *subview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        subview1.backgroundColor = [UIColor redColor];
        [view addSubview:subview1];
        
        UIView *subview2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxX(subview1.frame) + 10, 50, 50)];
        subview2.backgroundColor = [UIColor greenColor];
        [view addSubview:subview2];
        
        [view sizeToFit];
        
        _containerView1 = view;
    }
    
    return _containerView1;
}

- (UIView *)containerView2 {
    if (!_containerView2) {
        UIView *view = [UIView new];
        
        UIView *subview1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        subview1.backgroundColor = [UIColor redColor];
        [view addSubview:subview1];
        
        UIView *subview2 = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxX(subview1.frame) + 10, 50, 50)];
        subview2.backgroundColor = [UIColor greenColor];
        [view addSubview:subview2];
        
        [WCViewTool frameToFitAllSubviewsWithView:view];
        
        _containerView2 = view;
    }
    
    return _containerView2;
}


@end
