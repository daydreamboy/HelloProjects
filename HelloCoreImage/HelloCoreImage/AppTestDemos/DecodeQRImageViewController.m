//
//  DecodeQRImageViewController.m
//  HelloCoreImage
//
//  Created by wesley_chen on 2019/1/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "DecodeQRImageViewController.h"
#import "WCCoreImageTool.h"

@interface DecodeQRImageViewController ()

@end

@implementation DecodeQRImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *image = [UIImage imageNamed:@"QRCode1"];
    NSString *string = [WCCoreImageTool stringWithQRCodeImage:image];
    NSLog(@"%@", string);
}


@end
