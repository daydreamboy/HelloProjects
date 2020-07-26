//
//  UseTapGestureRecognizerViewController.m
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2020/7/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseTapGestureRecognizerViewController.h"

@interface UseTapGestureRecognizerViewController ()
@property (nonatomic, strong) UIView *roundView;
@end

@implementation UseTapGestureRecognizerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.roundView];
}

#pragma mark - Getter

- (UIView *)roundView {
    if (!_roundView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.7];
        
        _roundView = view;
    }
    
    return _roundView;
}

@end
