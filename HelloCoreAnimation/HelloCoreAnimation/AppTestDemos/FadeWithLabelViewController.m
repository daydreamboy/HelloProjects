//
//  FadeWithLabelViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/3/24.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "FadeWithLabelViewController.h"

@interface FadeWithLabelViewController ()
@property (nonatomic, strong) NSTimer *timerForUpdateLabel;
@property (nonatomic, strong) UILabel *label;
@end

@implementation FadeWithLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    label.text = @"abc";
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:20];
    label.textColor = [UIColor blackColor];
    label.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [self.view addSubview:label];
    _label = label;
    
    _timerForUpdateLabel = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(updateText:) userInfo:nil repeats:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_timerForUpdateLabel invalidate];
    _timerForUpdateLabel = nil;
}

- (void)updateText:(NSTimer *)timer {
    _label.layer.backgroundColor = [UIColor yellowColor].CGColor;
    
    [UIView transitionWithView:_label duration:0.5 options:UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionTransitionCrossDissolve animations:^{
        _label.text = [NSString stringWithFormat:@"%d", arc4random() % 100];
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _label.layer.backgroundColor = [UIColor whiteColor].CGColor;
        } completion:NULL];
        
    }];
}

@end
