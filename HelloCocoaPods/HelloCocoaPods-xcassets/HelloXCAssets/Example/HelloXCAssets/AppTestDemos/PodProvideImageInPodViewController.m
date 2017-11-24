//
//  PodProvideImageInPodViewController.m
//  HelloXCAssets_Example
//
//  Created by wesley_chen on 24/11/2017.
//  Copyright © 2017 daydreamboy. All rights reserved.
//

#import "PodProvideImageInPodViewController.h"
#import "Manager.h"

@interface PodProvideImageInPodViewController ()

@end

@implementation PodProvideImageInPodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_pod_provide_xcassets_image_in_pod];
}

- (void)test_pod_provide_xcassets_image_in_pod {
    UIImage *image1 = [Manager imageInPod];
    NSLog(@"image1: %@", image1);
    [self addImage:image1];
}

@end
