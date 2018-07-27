//
//  UseUILabelViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/7/23.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseUILabelViewController.h"
#import "WCStringTool.h"

@interface UseUILabelViewController ()
@property (nonatomic, strong) UILabel *labelEnglish;
@property (nonatomic, strong) UILabel *labelChinese;
@end

@implementation UseUILabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelEnglish];
    [self.view addSubview:self.labelChinese];
}

#pragma mark -

- (UILabel *)labelEnglish {
    if (!_labelEnglish) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 0, 0)];
        label.text = @"我";
        label.font = [UIFont systemFontOfSize:16];
        [label sizeToFit];
        CGSize textSize = [WCStringTool textSizeWithSingleLineString:label.text font:label.font];
        NSLog(@"1. %@", NSStringFromCGSize(textSize));
        
        _labelEnglish = label;
    }
    
    return _labelEnglish;
}

- (UILabel *)labelChinese {
    if (!_labelChinese) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 0, 0)];
        label.text = @"w";
        label.font = [UIFont systemFontOfSize:16];
        [label sizeToFit];
        CGSize textSize = [WCStringTool textSizeWithSingleLineString:label.text font:label.font];
        NSLog(@"2. %@", NSStringFromCGSize(textSize));
        
        _labelChinese = label;
    }
    
    return _labelChinese;
}

@end
