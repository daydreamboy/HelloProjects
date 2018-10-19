//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UIImagePNGRepresentationIssueViewController.h"

@interface UIImagePNGRepresentationIssueViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation UIImagePNGRepresentationIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
    [self.view addSubview:self.imageView];
    
    NSLog(@"Home: %@", NSHomeDirectory());
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/image.png"];
    
//    @autoreleasepool {
        UIImage *image = [UIImage imageNamed:@"XcodeBeta"];
        NSData *data = UIImagePNGRepresentation(image);
    [data writeToFile:filePath atomically:YES];
//        NSLog(@"data size: %ld bytes at address %p", (long)data.length, data);
    NSLog(@"%@", image);
    self.textField.text = [NSString stringWithFormat:@"%p", data];
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Getters

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 64 + 10, screenSize.width - 2 * 10, 30)];
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.enabled = NO;
        
        _textField = textField;
    }
    
    return _textField;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 200;
        CGFloat navH = 64;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - navH - side) / 2.0, side, side)];
        _imageView = imageView;
    }
    
    return _imageView;
}

@end
