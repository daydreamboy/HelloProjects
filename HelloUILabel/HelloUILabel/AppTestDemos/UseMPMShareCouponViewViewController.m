//
//  UseMPMShareCouponViewViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseMPMShareCouponViewViewController.h"
#import "MPMShareCouponView.h"

@interface UseMPMShareCouponViewViewController ()
@property (nonatomic, strong) MPMShareCouponView *mpmShareCouponView;
@end

@implementation UseMPMShareCouponViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.mpmShareCouponView];
}

#pragma mark - Getters

- (MPMShareCouponView *)mpmShareCouponView {
    if (!_mpmShareCouponView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        _mpmShareCouponView = [MPMShareCouponView new];
        _mpmShareCouponView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    }
    
    return _mpmShareCouponView;
}

@end
