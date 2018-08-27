//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "CenterImageInUIImageViewViewController.h"

@interface CenterImageInUIImageViewViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation CenterImageInUIImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.layer.cornerRadius = 20;
        imageView.layer.masksToBounds = YES;
        imageView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        imageView.image = [UIImage imageNamed:@"image.png"];
        imageView.contentMode = UIViewContentModeCenter;
        
        _imageView = imageView;
    }
    
    return _imageView;
}

- (UIImage*) roundCorneredImage:(UIImage *)orig radius:(CGFloat) r {
    UIGraphicsBeginImageContextWithOptions(orig.size, NO, 0);
    [[UIBezierPath bezierPathWithRoundedRect:(CGRect){CGPointZero, orig.size}
                                cornerRadius:r] addClip];
    [orig drawInRect:(CGRect){CGPointZero, orig.size}];
    UIImage* result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

@end
