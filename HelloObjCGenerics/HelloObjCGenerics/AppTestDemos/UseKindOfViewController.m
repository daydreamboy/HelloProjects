//
//  UseKindOfViewController.m
//  HelloObjCGenerics
//
//  Created by wesley_chen on 2018/10/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseKindOfViewController.h"

@interface UseKindOfViewController ()
@property (strong, nonatomic) NSMutableArray<UIView *> *subviews;
@property (strong, nonatomic) NSMutableArray<__kindof UIView *> *moreLooseSubviews;
@end

@implementation UseKindOfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *someView = [UIView new];
    [self.subviews addObject:someView];
    [self.moreLooseSubviews addObject:someView];
    
    UIButton *someButton = [UIButton new];
    [self.subviews addObject:someButton];
    [self.moreLooseSubviews addObject:someButton];
    
    __unused UIView *v1 = self.subviews[0];
    __unused UIView *v2 = self.moreLooseSubviews[0];
    
    // Warning: Incompatible pointer types initializing 'UIButton *' with an expression of type 'UIView *'
    __unused UIButton *b1 = [self.subviews objectAtIndex:0];
    
    // Fix Warning: Need type conversion
    __unused UIButton *b2 = (UIButton *)[self.subviews objectAtIndex:0];
    
    // Ok: no warning, use __kindof for UIButton is kind of UIView
    __unused UIButton *b3 = [self.moreLooseSubviews objectAtIndex:0];
}

#pragma mark - Getters

- (NSMutableArray<UIView *> *)subviews {
    if (!_subviews) {
        _subviews = [NSMutableArray array];
    }
    
    return _subviews;
}

- (NSMutableArray<UIView *> *)moreLooseSubviews {
    if (!_moreLooseSubviews) {
        _moreLooseSubviews = [NSMutableArray array];
    }
    
    return _moreLooseSubviews;
}

@end
