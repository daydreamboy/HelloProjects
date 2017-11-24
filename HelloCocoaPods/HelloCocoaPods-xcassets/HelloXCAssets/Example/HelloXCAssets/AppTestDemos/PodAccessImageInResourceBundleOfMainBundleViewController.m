//
//  PodAccessImageInResourceBundleOfMainBundleViewController.m
//  HelloXCAssets_Example
//
//  Created by wesley_chen on 24/11/2017.
//  Copyright © 2017 daydreamboy. All rights reserved.
//

#import "PodAccessImageInResourceBundleOfMainBundleViewController.h"
#import "Manager.h"

@interface PodAccessImageInResourceBundleOfMainBundleViewController ()

@end

@implementation PodAccessImageInResourceBundleOfMainBundleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test_pod_access_xcassets_image_in_resource_bundle_of_main_bundle];
}

- (void)test_pod_access_xcassets_image_in_resource_bundle_of_main_bundle {
    UIImage *image1 = [Manager imageInResourceBundleOfMainBundle];
    NSLog(@"image1: %@", image1);
    [self addImage:image1];
}

@end
