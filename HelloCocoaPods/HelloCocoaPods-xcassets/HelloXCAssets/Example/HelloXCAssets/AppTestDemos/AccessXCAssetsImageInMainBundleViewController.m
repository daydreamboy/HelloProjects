//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "AccessXCAssetsImageInMainBundleViewController.h"
#import <HelloXCAssets/Manager.h>
#import "WCXCAssetsImageTool.h"

@interface AccessXCAssetsImageInMainBundleViewController ()

@end

@implementation AccessXCAssetsImageInMainBundleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self test_access_xcassets_image_in_main_bundle];
}

- (void)test_access_xcassets_image_in_main_bundle {
    UIImage *image1 = [WCXCAssetsImageTool xcassetsImageNamed:@"picture_select" resourceBundleName:nil podName:@""];
    NSLog(@"image1: %@", image1);
    [self addImage:image1];
    
    UIImage *image2 = [WCXCAssetsImageTool xcassetsImageNamed:@"AppIcon" resourceBundleName:nil podName:@""];
    NSLog(@"image2: %@", image2);
    [self addImage:image2];
}

@end
