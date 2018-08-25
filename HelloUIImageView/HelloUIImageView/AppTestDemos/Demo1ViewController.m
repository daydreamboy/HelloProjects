//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"

@interface Demo1ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageView];
}

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1;
        imageView.backgroundColor = [UIColor yellowColor];
        imageView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        imageView.image = [UIImage imageNamed:@"image.png"];
        imageView.contentMode = UIViewContentModeCenter;
        
        _imageView = imageView;
    }
    
    return _imageView;
}
@end
