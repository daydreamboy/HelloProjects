//
//  UseCTLineViewController.m
//  HelloCoreText
//
//  Created by wesley_chen on 2019/4/23.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseCTLineViewController.h"
#import "LayoutALineView.h"

@interface UseCTLineViewController ()
@property (nonatomic, strong) LayoutALineView *drawableView;
@end

@implementation UseCTLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.drawableView];
}

- (LayoutALineView *)drawableView {
    if (!_drawableView) {
        _drawableView = [[LayoutALineView alloc] initWithFrame:CGRectMake(0, 80, 300, 400)];
        _drawableView.backgroundColor = [UIColor whiteColor];
        _drawableView.layer.borderColor = [UIColor redColor].CGColor;
        _drawableView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    }
    
    return _drawableView;
}

@end
