//
//  UseUIPanGestureRecognizer3ViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/7/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseUIPanGestureRecognizer3ViewController.h"
#import "WCViewTool.h"
#import "WCPannedView.h"

@interface UseUIPanGestureRecognizer3ViewController ()
@property (nonatomic, strong) WCPannedView *viewCircle;
@property (nonatomic, strong) UIView *viewRestricted;
@property (nonatomic, assign) CGPoint center;
@end

@implementation UseUIPanGestureRecognizer3ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.viewRestricted];
    [self.viewCircle addToView:self.viewRestricted];
}

#pragma mark - Getter

- (UIView *)viewRestricted {
    if (!_viewRestricted) {
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        CGSize size = CGRectInset(self.view.bounds, 20, 30).size;
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(20, startY + 30, size.width, size.height - startY)];
        view.layer.borderColor = [UIColor redColor].CGColor;
        view.layer.borderWidth = 1;
        view.clipsToBounds = YES;
        
        _viewRestricted = view;
    }
    
    return _viewRestricted;
}

- (UIView *)viewCircle {
    if (!_viewCircle) {
        CGFloat side = 50.0;
        WCPannedView *view = [[WCPannedView alloc] initWithFrame:CGRectMake(0, 0, side, side)];
        view.center = CGPointMake(CGRectGetWidth(_viewRestricted.bounds) / 2.0, CGRectGetHeight(_viewRestricted.bounds) / 2.0);
        
        view.contentView.layer.cornerRadius = side / 2.0;
        view.contentView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.8];
        
        _viewCircle = view;
    }
    
    return _viewCircle;
}

#pragma mark - Actions


@end
