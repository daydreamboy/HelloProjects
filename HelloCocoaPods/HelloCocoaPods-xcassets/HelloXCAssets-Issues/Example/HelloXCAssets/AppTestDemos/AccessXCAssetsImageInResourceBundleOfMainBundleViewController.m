//
//  AccessXCAssetsImageInResourceBundleOfMainBundleViewController.m
//  HelloXCAssets_Example
//
//  Created by wesley_chen on 23/11/2017.
//  Copyright © 2017 daydreamboy. All rights reserved.
//

#import "AccessXCAssetsImageInResourceBundleOfMainBundleViewController.h"
#import "WCXCAssetsImageTool.h"

@interface AccessXCAssetsImageInResourceBundleOfMainBundleViewController ()

@end

@implementation AccessXCAssetsImageInResourceBundleOfMainBundleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test_access_xcassets_image_in_resource_bundle_of_main_bundle];
}

- (void)test_access_xcassets_image_in_resource_bundle_of_main_bundle {
    UIImage *image1 = [WCXCAssetsImageTool xcassetsImageNamed:@"shopping" resourceBundleName:@"main" podName:@""];
    NSLog(@"image1: %@", image1);
    [self addImage:image1];
    
    UIImage *image2 = [WCXCAssetsImageTool xcassetsImageNamed:@"wuliu" resourceBundleName:@"main" podName:@""];
    NSLog(@"image2: %@", image2);
    [self addImage:image2];
}

@end
