//
//  PodAccessImageInMainBundleViewController.m
//  HelloXCAssets_Example
//
//  Created by wesley_chen on 24/11/2017.
//  Copyright © 2017 daydreamboy. All rights reserved.
//

#import "PodAccessImageInMainBundleViewController.h"
#import "Manager.h"

@interface PodAccessImageInMainBundleViewController ()

@end

@implementation PodAccessImageInMainBundleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test_pod_access_xcassets_image_in_main_bundle];
}

- (void)test_pod_access_xcassets_image_in_main_bundle {
    UIImage *image1 = [Manager imageInMainBundle];
    NSLog(@"image1: %@", image1);
    [self addImage:image1];
}

@end
