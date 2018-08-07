//
//  UseMPMShareLinkViewViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseMPMShareLinkViewViewController.h"
#import "MPMShareLinkView.h"

@interface UseMPMShareLinkViewViewController ()
@property (nonatomic, strong) MPMShareLinkView *mpmShareLinkView;
@end

@implementation UseMPMShareLinkViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mpmShareLinkView];
}

#pragma mark - Getters

- (MPMShareLinkView *)mpmShareLinkView {
    if (!_mpmShareLinkView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        _mpmShareLinkView = [MPMShareLinkView new];
        _mpmShareLinkView.title = @"标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题标题";
        _mpmShareLinkView.subtitle = @"正文";
        _mpmShareLinkView.numberOfLinesForTitle = 2;
        _mpmShareLinkView.sourceTitle = @"分享链接";
        _mpmShareLinkView.imageViewPreviewHidden = YES;
        _mpmShareLinkView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    }
    
    return _mpmShareLinkView;
}

@end
