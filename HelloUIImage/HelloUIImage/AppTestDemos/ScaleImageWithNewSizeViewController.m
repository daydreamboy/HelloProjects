//
//  ScaleImageWithNewSizeViewController.m
//  AppTest
//
//  Created by wesley_chen on 2018/5/6.
//

#import "ScaleImageWithNewSizeViewController.h"
#import "WCImageTool.h"

@interface ScaleImageWithNewSizeViewController ()
@property (nonatomic, strong) UIImageView *imageViewOriginal;
@property (nonatomic, strong) UIImageView *imageViewScaled;
@end

@implementation ScaleImageWithNewSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewOriginal];
    [self.view addSubview:self.imageViewScaled];
}

#pragma mark - Getters

- (UIImageView *)imageViewOriginal {
    if (!_imageViewOriginal) {
        UIImage *image = [UIImage imageNamed:@"10"];
        CGSize imageSize = image.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 10, imageSize.width, imageSize.height)];
        imageView.image = image;
        
        _imageViewOriginal = imageView;
    }
    
    return _imageViewOriginal;
}

- (UIImageView *)imageViewScaled {
    if (!_imageViewScaled) {
        UIImage *image = [UIImage imageNamed:@"10"];
        CGSize imageSize = image.size;
        image = [WCImageTool imageWithImage:image scaledToSize:CGSizeMake(imageSize.width * 2, imageSize.height * 2)];
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 300, image.size.width, image.size.height)];
        imageView.image = image;
        
        _imageViewScaled = imageView;
    }
    
    return _imageViewScaled;
}

@end
