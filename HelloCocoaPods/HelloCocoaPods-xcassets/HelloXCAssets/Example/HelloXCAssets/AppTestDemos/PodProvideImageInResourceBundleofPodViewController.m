//
//  PodProvideImageInResourceBundleofPodViewController.m
//  HelloXCAssets_Example
//
//  Created by wesley_chen on 24/11/2017.
//  Copyright © 2017 daydreamboy. All rights reserved.
//

#import "PodProvideImageInResourceBundleofPodViewController.h"
#import "Manager.h"

@interface PodProvideImageInResourceBundleofPodViewController ()

@end

@implementation PodProvideImageInResourceBundleofPodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_pod_provide_xcassets_image_in_resource_bundle_of_pod];
}

- (void)test_pod_provide_xcassets_image_in_resource_bundle_of_pod {
    UIImage *image1 = [Manager imageInResourceBundleOfPod];
    NSLog(@"image1: %@", image1);
    [self addImage:image1];
}

@end
