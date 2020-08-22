//
//  UseIconFontInUILabelViewController.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseIconFontInUILabelViewController.h"
#import "WCFontTool.h"

@interface UseIconFontInUILabelViewController ()
@property (nonatomic, strong) UILabel *labelUseFontResigteredInfoPlist;
@property (nonatomic, strong) UILabel *labelUseFontResigteredViaRuntime;
@property (nonatomic, strong) NSString *fontName;
@end

@implementation UseIconFontInUILabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *fontFilePath = [[NSBundle mainBundle] pathForResource:@"app_font/iconfont" ofType:@"ttf"];
    NSString *fontName;
    [WCFontTool registerFontWithFilePath:fontFilePath fontName:&fontName error:nil];
    self.fontName = fontName;
    
    [self.view addSubview:self.labelUseFontResigteredInfoPlist];
    [self.view addSubview:self.labelUseFontResigteredViaRuntime];
}

- (UILabel *)labelUseFontResigteredInfoPlist {
    if (!_labelUseFontResigteredInfoPlist) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 60)];
        label.font = [WCFontTool fontWithName:self.fontName fontSize:20];
        label.text = @"Display a \U0000C03A, \uC03A on label \uEEA0";
        
        _labelUseFontResigteredInfoPlist = label;
    }
    
    return _labelUseFontResigteredInfoPlist;
}

- (UILabel *)labelUseFontResigteredViaRuntime {
    if (!_labelUseFontResigteredViaRuntime) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_labelUseFontResigteredInfoPlist.frame), screenSize.width, 60)];
        label.font = [WCFontTool fontWithName:@"icofont" fontSize:20];
        label.text = @"Display a \U0000EEA0, \uEEA0 on label \U0000C03A";
        
        _labelUseFontResigteredViaRuntime = label;
    }
    
    return _labelUseFontResigteredViaRuntime;
}

@end
