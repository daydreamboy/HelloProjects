//
//  CreateImageWithAlphaViewController.m
//  AppTest
//
//  Created by wesley_chen on 2018/5/6.
//

#import "CreateImageWithAlphaViewController.h"
#import "WCImageTool.h"

@interface CreateImageWithAlphaViewController ()
@property (nonatomic, strong) UIImageView *imageViewOriginal;
@property (nonatomic, strong) UIImageView *imageViewAlphaed;
@end

@implementation CreateImageWithAlphaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewOriginal];
    [self.view addSubview:self.imageViewAlphaed];
}

#pragma mark - Getters

- (UIImageView *)imageViewOriginal {
    if (!_imageViewOriginal) {
        UIImage *image = [UIImage imageNamed:@"6"];
        CGSize imageSize = image.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 64 + 10, imageSize.width, imageSize.height)];
        imageView.image = image;
        
        _imageViewOriginal = imageView;
    }
    
    return _imageViewOriginal;
}

- (UIImageView *)imageViewAlphaed {
    if (!_imageViewAlphaed) {
        UIImage *image = [UIImage imageNamed:@"6"];
        CGSize imageSize = image.size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 300, imageSize.width, imageSize.height)];
        imageView.image = [WCImageTool imageWithImage:image alpha:0.5];
        
        _imageViewAlphaed = imageView;
    }
    
    return _imageViewAlphaed;
}

@end
