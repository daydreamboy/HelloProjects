//
//  UseUILabelViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/7/23.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseUILabelViewController.h"
#import "WCStringTool.h"
#import "WCMacroTool.h"
#import "YYLabel.h"

@interface UseUILabelViewController ()
@property (nonatomic, strong) UILabel *labelEnglish;
@property (nonatomic, strong) UILabel *labelChinese;
@property (nonatomic, strong) YYLabel *label;
@end

@implementation UseUILabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelEnglish];
    [self.view addSubview:self.labelChinese];
    [self.view addSubview:self.label];
    
    YYTextDebugOption *debugOptions = [YYTextDebugOption new];
//    if (debug) {
        debugOptions.baselineColor = [UIColor redColor];
        debugOptions.CTFrameBorderColor = [UIColor redColor];
        debugOptions.CTLineFillColor = [UIColor colorWithRed:0.000 green:0.463 blue:1.000 alpha:0.180];
        debugOptions.CGGlyphBorderColor = [UIColor colorWithRed:1.000 green:0.524 blue:0.000 alpha:0.200];
//    } else {
//        [debugOptions clear];
//    }
    [YYTextDebugOption setSharedDebugOption:debugOptions];
}

#pragma mark -

- (UILabel *)labelEnglish {
    if (!_labelEnglish) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 60)];
        label.text = @"文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本文本";
        label.numberOfLines = 1;
        label.font = [UIFont systemFontOfSize:28];
        label.contentMode = UIViewContentModeTop;
        label.backgroundColor = [UIColor greenColor];
        [label sizeToFit];
//        CGSize textSize = [WCStringTool textSizeWithSingleLineString:label.text font:label.font];
//        NSLog(@"1. %@", NSStringFromCGSize(textSize));
        
        _labelEnglish = label;
    }
    
    return _labelEnglish;
}

- (UILabel *)labelChinese {
    if (!_labelChinese) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 200, 0, 0)];
        label.text = @"w";
        label.font = [UIFont systemFontOfSize:16];
        label.backgroundColor = [UIColor greenColor];
        [label sizeToFit];
        CGSize textSize = [WCStringTool textSizeWithSingleLineString:label.text font:label.font];
        NSLog(@"2. %@", NSStringFromCGSize(textSize));
        
        _labelChinese = label;
    }
    
    return _labelChinese;
}

- (YYLabel *)label {
    if (!_label) {
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(100, 300, 0, 0)];
        label.userInteractionEnabled = YES;
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByWordWrapping;
        label.attributedText = [self createAttrStringWithText:@"文本文本文本文本文本文本文本文本文本文本文本文本文本"];
//        label.textVerticalAlignment = YYTextVerticalAlignmentCenter;
//        label.backgroundColor = [UIColor greenColor];
        
        [label sizeToFit];
        
        _label = label;
    }
    
    return _label;
}

#pragma mark -

- (NSAttributedString *)createAttrStringWithText:(NSString *)text {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.alignment = NSTextAlignmentLeft;
//    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    NSDictionary *attrs = @{
                            NSFontAttributeName: ([UIFont systemFontOfSize:28]),
                            NSForegroundColorAttributeName: UICOLOR_RGB(0x322C06),
//                            NSParagraphStyleAttributeName: paragraphStyle
                            };
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:text attributes:attrs];
    
    NSMutableAttributedString *attributedText = [NSMutableAttributedString new];
    [attributedText appendAttributedString:attrString];
    
    return attributedText;
}

@end
