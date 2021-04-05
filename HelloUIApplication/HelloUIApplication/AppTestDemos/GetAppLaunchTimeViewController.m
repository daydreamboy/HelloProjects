//
//  GetAppLaunchTimeViewController.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/3/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "GetAppLaunchTimeViewController.h"
#import "WCApplicationTool.h"

@interface GetAppLaunchTimeViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UILabel *label;
@end

@implementation GetAppLaunchTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timerFired:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.timer invalidate];
    self.timer = nil;
}

- (void)dealloc {
    NSLog(@"_cmd: %@, %@", NSStringFromSelector(_cmd), self);
}

#pragma mark - Getter

- (UILabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 80)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor blackColor];
        label.numberOfLines = 0;
        
        _label = label;
    }
    
    return _label;
}

#pragma mark - NSTimer

- (void)timerFired:(id)timer {
    NSTimeInterval ts = [WCApplicationTool appProcessStartTime];
    NSLog(@"%f", ts);
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.label.text = [[NSDate dateWithTimeIntervalSince1970:ts] descriptionWithLocale:[NSLocale currentLocale]];
    
    CGPoint pointInScreen = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    CGPoint pointInSelfView = [self.view.window convertPoint:pointInScreen toView:self.view];
    
    self.label.center = pointInSelfView;
}

@end
