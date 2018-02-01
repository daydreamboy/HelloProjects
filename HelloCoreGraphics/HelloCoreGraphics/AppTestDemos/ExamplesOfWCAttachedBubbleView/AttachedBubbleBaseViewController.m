//
//  AttachedBubbleBaseViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 12/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "AttachedBubbleBaseViewController.h"

#define SPACE_V 30

@interface AttachedBubbleBaseViewController ()
@property (nonatomic, strong) UIView *viewInCenter;
@end

@implementation AttachedBubbleBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
        
    [self.view addSubview:self.viewInCenter];
}

- (WCAttachedBubbleView *)bubbleView1WithArrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    label.text = @"Bubble 1";
    
    WCAttachedBubbleView *view = [WCAttachedBubbleView viewWithContentView:label arrowDirection:arrowDirection];
    view.arrowPosition = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    view.borderColor = [UIColor orangeColor];
    view.borderWidth = 4;
    
    self.bubbleView1PlacedByFrame = view;
    
    return view;
}

- (WCAttachedBubbleView *)bubbleView2WithArrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    label.text = @"Bubble 2";
    
    WCAttachedBubbleView *view = [WCAttachedBubbleView viewWithContentView:label arrowDirection:arrowDirection];
    view.frame = CGRectMake(0, 100, 200, 40);
    view.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    
    self.bubbleView2PlacedByArrowPosition = view;
    
    return view;
}

- (WCAttachedBubbleView *)bubbleView3WithArrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.layer.borderColor = [UIColor whiteColor].CGColor;
    label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    label.text = @"Bubble 3";
    label.textColor = [UIColor whiteColor];
    
    WCAttachedBubbleView *view = [WCAttachedBubbleView viewWithContentView:label arrowDirection:arrowDirection];
    view.frame = CGRectMake(0, 100 + 40 + SPACE_V, 200, 40);
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    view.borderWidth = 1;
    view.borderColor = [UIColor whiteColor];
    view.shadowOpacity = 0.9;
    view.shadowColor = [UIColor blackColor];
    view.shadowOffset = CGSizeMake(-1, -1);
    view.contentInsets = UIEdgeInsetsMake(5, -5, -5, 5);
    
    self.bubbleView3WithShadow = view;
    
    return view;
}

- (WCAttachedBubbleView *)bubbleView4WithArrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection {
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.layer.borderColor = [UIColor grayColor].CGColor;
    label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    label.text = @"Bubble 4";
    
    WCAttachedBubbleView *view = [WCAttachedBubbleView viewWithContentView:label arrowDirection:arrowDirection];
    view.arrowPosition = CGPointMake(screenSize.width - 20, screenSize.height / 3.0);
    view.borderColor = [UIColor orangeColor];
    view.borderWidth = 1;
    view.constrainedRectInMainScreen = [UIScreen mainScreen].bounds;
    
    self.bubbleView4WithconstrainedRectInMainScreen = view;
    
    return view;
}

#pragma mark - Getters

- (UIView *)viewInCenter {
    if (!_viewInCenter) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        view.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.2];
        _viewInCenter = view;
    }
    
    return _viewInCenter;
}

@end
