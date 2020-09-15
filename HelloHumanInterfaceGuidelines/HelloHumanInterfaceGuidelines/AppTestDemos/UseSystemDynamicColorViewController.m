//
//  UseSystemDynamicColorViewController.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseSystemDynamicColorViewController.h"

@interface UseSystemDynamicColorViewController ()

@end

@implementation UseSystemDynamicColorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithDynamicProvider:^UIColor * _Nonnull(UITraitCollection * _Nonnull traitCollection) {
        if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
            return [UIColor greenColor];
        }
        else if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleLight) {
            return [UIColor redColor];
        }
        else if (traitCollection.userInterfaceStyle == UIUserInterfaceStyleUnspecified) {
            return [UIColor yellowColor];
        }
        
        return [UIColor whiteColor];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Change" style:UIBarButtonItemStylePlain target:self action:@selector(change:)];
    
    UIColor *dynamicColor = [UIColor systemBackgroundColor];
    UIColor *resovedColor = [dynamicColor resolvedColorWithTraitCollection:self.traitCollection];
    NSLog(@"%@", dynamicColor);
    NSLog(@"%@", resovedColor);
}

- (void)change:(id)sender {
    @try {
        [self.view.backgroundColor setValue:[UIColor orangeColor].CGColor forKey:@"CGColor"];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception);
    }
}


@end
