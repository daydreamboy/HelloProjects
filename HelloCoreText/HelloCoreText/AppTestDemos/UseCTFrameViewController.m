//
//  UseCTFrameViewController.m
//  HelloCoreText
//
//  Created by wesley_chen on 2019/4/23.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseCTFrameViewController.h"
#import "LayoutAParagraphView.h"

@interface UseCTFrameViewController ()
@property (nonatomic, strong) LayoutAParagraphView *drawableView;
@end

@implementation UseCTFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.drawableView];
}

- (LayoutAParagraphView *)drawableView {
    if (!_drawableView) {
        _drawableView = [[LayoutAParagraphView alloc] initWithFrame:CGRectMake(0, 80, 300, 400)];
        _drawableView.backgroundColor = [UIColor whiteColor];
        _drawableView.layer.borderColor = [UIColor redColor].CGColor;
        _drawableView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
    }
    
    return _drawableView;
}

@end
