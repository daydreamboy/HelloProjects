//
//  UseIconFontInUIButtonViewController.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseIconFontInUIButtonViewController.h"
#import "WCIconFontTool.h"

@interface UseIconFontInUIButtonViewController ()
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) NSString *fontName;
@end

@implementation UseIconFontInUIButtonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *fontFilePath = [[NSBundle mainBundle] pathForResource:@"app_font/iconfont" ofType:@"ttf"];
    NSString *fontName;
    [WCIconFontTool registerIconFontWithFilePath:fontFilePath fontName:&fontName error:nil];
    self.fontName = fontName;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.titleLabel.font = [UIFont fontWithName:fontName size:22];
    [button setTitle:@"\U0000B04A" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//    [button sizeToFit];
    //[button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *settingItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = settingItem;
}

@end
