//
//  CreateOnePixelHeightLineViewController.m
//  AppTest
//
//  Created by wesley_chen on 2018/4/16.
//

#import "CreateOnePixelHeightLineViewController.h"
#import "WCImageTool.h"

@implementation UIImage (Wrong)

+ (UIImage *)wrong_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

@interface CreateOnePixelHeightLineViewController ()
@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;
@end

@implementation CreateOnePixelHeightLineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Note: create 1px height, e.g 0.5pt on @2x device, 0.333pt on @3x device
    [self.view addSubview:self.imageView1];
    [self.view addSubview:self.imageView2];
}

#pragma mark - Getters

- (UIImageView *)imageView1 {
    if (!_imageView1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIImage *image = [WCImageTool imageWithColor:[UIColor redColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, screenSize.width, image.size.height)];
        imageView.image = image;
        _imageView1 = imageView;
    }
    
    return _imageView1;
}

- (UIImageView *)imageView2 {
    if (!_imageView2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIImage *image = [UIImage wrong_imageWithColor:[UIColor redColor]];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 105, screenSize.width, image.size.height)];
        imageView.image = image;
        _imageView2 = imageView;
    }
    
    return _imageView2;
}

@end
