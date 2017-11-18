//
//  ViewController.m
//  HelloWeex
//
//  Created by wesley_chen on 17/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "ViewController.h"
#import <WeexSDK/WXSDKInstance.h>

@interface ViewController ()
@property (nonatomic, strong) WXSDKInstance *instance;
@property (nonatomic, strong) UIView *weexView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _instance = [[WXSDKInstance alloc] init];
    _instance.viewController = self;
    _instance.frame = self.view.frame;
    __weak typeof(self) weakSelf = self;
    _instance.onCreate = ^(UIView *view) {
        [weakSelf.weexView removeFromSuperview];
        weakSelf.weexView = view;
        [weakSelf.view addSubview:weakSelf.weexView];
    };
    _instance.onFailed = ^(NSError *error) {
        //process failure
    };
    _instance.renderFinish = ^ (UIView *view) {
        //process renderFinish
    };
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"main" withExtension:@"js"];
    //[_instance renderWithURL:url options:@{@"bundleUrl":[self.url absoluteString]} data:nil];
    [_instance renderWithURL:url options:nil data:nil];
}

- (void)dealloc {
    [_instance destroyInstance];
}

@end
