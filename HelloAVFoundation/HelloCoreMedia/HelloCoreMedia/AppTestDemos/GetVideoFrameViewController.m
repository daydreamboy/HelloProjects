//
//  GetVideoFrameViewController.m
//  HelloAVMedia
//
//  Created by wesley_chen on 2019/8/8.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "GetVideoFrameViewController.h"
#import "WCImageTool.h"

@interface GetVideoFrameViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation GetVideoFrameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Fuego_de_Refineria" ofType:@"mp4"];
    UIImage *image = [WCImageTool imageWithVideoFilePath:filePath frameTimestamp:0];
    
    self.imageView.image = image;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        
        _imageView = imageView;
    }
    
    return _imageView;
}

@end
