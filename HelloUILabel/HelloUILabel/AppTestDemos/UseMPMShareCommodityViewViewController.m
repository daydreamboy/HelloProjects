//
//  UseMPMShareCommodityViewViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseMPMShareCommodityViewViewController.h"
#import "MPMShareCommodityView.h"

@interface UseMPMShareCommodityViewViewController ()
@property (nonatomic, strong) MPMShareCommodityView *mpmShareCommodityView;
@end

@implementation UseMPMShareCommodityViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mpmShareCommodityView];
}

#pragma mark - Getters

- (MPMShareCommodityView *)mpmShareCommodityView {
    if (!_mpmShareCommodityView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        _mpmShareCommodityView = [MPMShareCommodityView new];
        _mpmShareCommodityView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    }
    
    return _mpmShareCommodityView;
}

@end
