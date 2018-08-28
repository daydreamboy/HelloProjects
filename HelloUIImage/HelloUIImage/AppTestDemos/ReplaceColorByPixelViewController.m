//
//  ReplaceColorByPixelViewController.m
//  AppTest
//
//  Created by wesley_chen on 2018/5/4.
//

#import "ReplaceColorByPixelViewController.h"
#import "WCImageTool.h"

@interface ReplaceColorByPixelViewController ()
@property (nonatomic, strong) UIImageView *imageViewOriginal;
@property (nonatomic, strong) UIImageView *imageViewChanged;
@property (nonatomic, strong) UIImageView *imageViewCaptcha;
@end

@implementation ReplaceColorByPixelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.imageViewOriginal];
    [self.view addSubview:self.imageViewChanged];
    [self.view addSubview:self.imageViewCaptcha];
    
    // Note: copy not work on image
    /*
    UIImage *imageCopied = [self.imageViewOriginal.image copy];
    self.imageViewChanged.image = imageCopied;
     */
    [self test_replace_pixel_colors];
}

- (UIImage *)createColorfulImageWithImageSize:(CGSize)imageSize {
    UIImage *image = [WCImageTool imageWithColor:[UIColor whiteColor] size:imageSize];
    
    CGSize smallImageSize = CGSizeMake(50, 50);
    image = [WCImageTool drawImage:[WCImageTool imageWithColor:[UIColor redColor] size:smallImageSize] inParentImage:image placedAt:CGRectMake(0, 0, smallImageSize.width, smallImageSize.height)];
    image = [WCImageTool drawImage:[WCImageTool imageWithColor:[UIColor greenColor] size:smallImageSize] inParentImage:image placedAt:CGRectMake(50, 0, smallImageSize.width, smallImageSize.height)];
    image = [WCImageTool drawImage:[WCImageTool imageWithColor:[UIColor blueColor] size:smallImageSize] inParentImage:image placedAt:CGRectMake(0, 50, smallImageSize.width, smallImageSize.height)];
    image = [WCImageTool drawImage:[WCImageTool imageWithColor:[UIColor yellowColor] size:smallImageSize] inParentImage:image placedAt:CGRectMake(50, 50, smallImageSize.width, smallImageSize.height)];
    
    return image;
}

#pragma mark - Test Methods

- (void)test_replace_pixel_colors {
    UIImage *destImage = self.imageViewChanged.image;
    
    CGFloat red[6] = { 255.0, 255.0, 0.0, 0.0, 0.0, 0.0 };
    CGFloat green[6] = { 0, 0, 255, 255, 0, 0 };
    CGFloat blue[6] = { 0, 0, 0, 0, 255, 255 };
    CGFloat yellow[6] = { 255, 255, 255, 255, 0, 0 };
    
    // TODO: 
    
    // red to magentaColor
    destImage = [WCImageTool setImage:destImage replaceColorComponents:red toColor:[UIColor magentaColor]];
//    // green to grayColor
//    destImage = [WCImageTool imageWithImage:destImage replaceColorComponents:green toColor:[UIColor grayColor]];
//    // blue to blackColor
//    destImage = [WCImageTool imageWithImage:destImage replaceColorComponents:blue toColor:[UIColor blackColor]];
//    // yellow to orangeColor
//    destImage = [WCImageTool imageWithImage:destImage replaceColorComponents:yellow toColor:[UIColor orangeColor]];
    
    self.imageViewChanged.image = destImage;
}

#pragma mark - Getters

- (UIImageView *)imageViewOriginal {
    if (!_imageViewOriginal) {
        CGSize imageSize = CGSizeMake(100, 100);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, imageSize.width, imageSize.height)];
        imageView.image = [self createColorfulImageWithImageSize:imageSize];
        
        _imageViewOriginal = imageView;
    }
    
    return _imageViewOriginal;
}

- (UIImageView *)imageViewChanged {
    if (!_imageViewChanged) {
        CGSize imageSize = CGSizeMake(100, 100);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 280, imageSize.width, imageSize.height)];
        imageView.image = [self createColorfulImageWithImageSize:imageSize];
        
        _imageViewChanged = imageView;
    }
    
    return _imageViewChanged;
}


- (UIImageView *)imageViewCaptcha {
    if (!_imageViewCaptcha) {
        
        CGSize size = CGSizeMake(230, 60);
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - size.width) / 2.0, 400, size.width, size.height)];
        imageView.backgroundColor = [UIColor lightGrayColor];
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewCaptchaTapped:)];
        [imageView addGestureRecognizer:tapRecognizer];
        
        _imageViewCaptcha = imageView;
    }
    
    return _imageViewCaptcha;
}

- (void)imageViewCaptchaTapped:(UITapGestureRecognizer *)tapRecognizer {
    UIView *tappedView = tapRecognizer.view;
    if (tappedView == self.imageViewCaptcha) {
        [self refreshCaptcha];
    }
}

- (void)refreshCaptcha {
    NSString *name = [NSString stringWithFormat:@"%d.jpeg", arc4random() % 5 + 1];
        name = @"8";
    UIImage *image = [UIImage imageNamed:name];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGRect frame = self.imageViewCaptcha.frame;
    frame.size.width = image.size.width;
    frame.size.height = image.size.height;
    
    frame.origin.x = (screenSize.width - frame.size.width) / 2.0;
    frame.origin.y = 400;
    
    self.imageViewCaptcha.frame = frame;
    
    const CGFloat colorMasking[6] = {
        // RGB
        222, 255, 222, 255, 222, 255
    };
    
    self.imageViewCaptcha.image = [WCImageTool setImage:image replaceColorComponents:(CGFloat *)colorMasking toColor:[UIColor redColor]];
}

@end
