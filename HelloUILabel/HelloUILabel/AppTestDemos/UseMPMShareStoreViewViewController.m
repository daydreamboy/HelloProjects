//
//  UseMPMShareStoreViewViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseMPMShareStoreViewViewController.h"
#import "MPMShareStoreView.h"

@interface UseMPMShareStoreViewViewController ()
@property (nonatomic, strong) MPMShareStoreView *mpmShareStoreView;
@end

@implementation UseMPMShareStoreViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.mpmShareStoreView];
}

#pragma mark - Getters

- (MPMShareStoreView *)mpmShareStoreView {
    if (!_mpmShareStoreView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        _mpmShareStoreView = [MPMShareStoreView new];
        _mpmShareStoreView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    }
    
    return _mpmShareStoreView;
}

@end
