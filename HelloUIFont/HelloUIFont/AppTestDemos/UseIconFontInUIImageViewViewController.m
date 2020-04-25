//
//  UseIconFontInUIImageViewViewController.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseIconFontInUIImageViewViewController.h"
#import "WCIconFontTool.h"

@interface UseIconFontInUIImageViewViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) NSString *fontName;
@end

@implementation UseIconFontInUIImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *fontFilePath = [[NSBundle mainBundle] pathForResource:@"app_font/iconfont" ofType:@"ttf"];
    NSString *fontName;
    [WCIconFontTool registerIconFontWithFilePath:fontFilePath fontName:&fontName error:nil];
    self.fontName = fontName;
    
    [self.view addSubview:self.imageView];
}

#pragma mark -

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 80, 80, 80)];
        imageView.image = [WCIconFontTool imageWithIconFontName:self.fontName text:@"\U0000B04A" fontSize:25 color:[UIColor orangeColor]];
        imageView.layer.borderColor = [UIColor redColor].CGColor;
        imageView.layer.borderWidth = 1;
        
        _imageView = imageView;
    }
    
    return _imageView;
}

@end
