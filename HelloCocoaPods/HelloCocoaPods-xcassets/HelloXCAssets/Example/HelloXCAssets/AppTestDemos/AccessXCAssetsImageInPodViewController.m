//
//  AccessXCAssetsImageInPodViewController.m
//  HelloXCAssets_Example
//
//  Created by wesley_chen on 23/11/2017.
//  Copyright © 2017 daydreamboy. All rights reserved.
//

#import "AccessXCAssetsImageInPodViewController.h"
#import "WCXCAssetsImageTool.h"
#import "Manager.h"

@interface AccessXCAssetsImageInPodViewController ()

@end

@implementation AccessXCAssetsImageInPodViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self test_access_xcassets_image_in_pod];
}

- (void)test_access_xcassets_image_in_pod {
    UIImage *image1 = [WCXCAssetsImageTool xcassetsImageNamed:@"shop" resourceBundleName:nil podName:@"HelloXCAssets"];
    NSLog(@"image1: %@", image1);
    [self addImage:image1];
    
    UIImage *image2 = [WCXCAssetsImageTool xcassetsImageNamed:@"favourited" resourceBundleName:nil podName:@"HelloXCAssets"];
    NSLog(@"image2: %@", image2);
    
    [self addImage:image2];
}

@end
