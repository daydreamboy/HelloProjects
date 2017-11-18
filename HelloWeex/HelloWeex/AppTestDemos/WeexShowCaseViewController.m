//
//  WeexShowCaseViewController.m
//  HelloWeex
//
//  Created by wesley_chen on 18/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "WeexShowCaseViewController.h"
#import <WeexSDK/WeexSDK.h>

@interface WeexShowCaseViewController ()
@property (nonatomic, strong) WXSDKInstance *weexSDK;
@property (nonatomic, strong) NSString *weexUrl;
@end

@implementation WeexShowCaseViewController

- (instancetype)initWithWeexUrl:(NSString *)weexUrl {
    self = [super init];
    if (self) {
        _weexUrl = weexUrl;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.weexSDK.viewController = self;
    self.weexSDK.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64);
    
    [self.weexSDK renderWithURL:[NSURL URLWithString:self.weexUrl]];
    
    __weak typeof(self) weakSelf = self;
    self.weexSDK.onCreate = ^(UIView *view) {
        NSLog(@"weexSDK onCreate");
        [weakSelf.view addSubview:view];
    };
    
    self.weexSDK.renderFinish = ^(UIView *view) {
        NSLog(@"weexSDK renderFinish");
    };
    
    self.weexSDK.onFailed = ^(NSError *error) {
        NSLog(@"weexSDK onFailed : %@\n", error);
    };
}

- (void)dealloc {
    [_weexSDK destroyInstance];
}

#pragma mark - Getters

- (WXSDKInstance *)weexSDK {
    if (!_weexSDK) {
        _weexSDK = [WXSDKInstance new];
    }
    return _weexSDK;
}

@end
