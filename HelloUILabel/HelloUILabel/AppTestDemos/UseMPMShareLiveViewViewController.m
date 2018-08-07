//
//  UseMPMShareLiveViewViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/7.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseMPMShareLiveViewViewController.h"
#import "MPMShareLiveView.h"

@interface UseMPMShareLiveViewViewController ()
@property (nonatomic, strong) MPMShareLiveView *mpmShareLiveView;
@end

@implementation UseMPMShareLiveViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.mpmShareLiveView];
}

#pragma mark - Getters

- (MPMShareLiveView *)mpmShareLiveView {
    if (!_mpmShareLiveView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        _mpmShareLiveView = [MPMShareLiveView new];
        _mpmShareLiveView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        _mpmShareLiveView.title = @"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题";
        _mpmShareLiveView.sourceTitle = @"类型来源";
        _mpmShareLiveView.playbackTitle = @"回放";
        _mpmShareLiveView.labelAvatarName.text = @"我的薛之谦";
    }
    
    return _mpmShareLiveView;
}

@end
