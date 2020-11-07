//
//  ShowLinkWithWCLabelViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/11/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShowLinkWithWCLabelViewController.h"
#import "WCLinkLabel.h"
#import "WCStringTool.h"

@interface ShowLinkWithWCLabelViewController ()
@property (nonatomic, strong) UILabel *labelSystem;
@property (nonatomic, strong) WCLinkLabel *label;
@end

@implementation ShowLinkWithWCLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelSystem];
    [self.view addSubview:self.label];
}

#pragma mark - Getter

- (UILabel *)labelSystem {
    if (!_labelSystem) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 150)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 0;
        label.attributedText = ({
            NSString *string = @"This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... ";
            
            NSString *linkString = @"https://www.baidu.com";
            NSArray<NSValue *> *ranges = [WCStringTool rangesOfSubstringWithString:string substring:linkString];
            
            NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithString:string attributes:@{
                NSFontAttributeName: [UIFont systemFontOfSize:17],
            }];
            
            for (NSValue *value in ranges) {
                NSRange linkRange = [value rangeValue];
                [attrStringM addAttributes:@{
                    NSForegroundColorAttributeName: [UIColor greenColor],
                    NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
                    NSUnderlineColorAttributeName: [UIColor colorWithRed:51 / 255.0 green:154 / 255.0 blue:1.0 alpha:1.0],
                } range:linkRange];
            }
            
            attrStringM;
        });
        
        _labelSystem = label;
    }
    
    return _labelSystem;
}

- (WCLinkLabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCLinkLabel *label = [[WCLinkLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_labelSystem.frame) + 20, screenSize.width, 150)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 0;
        label.attributedText = ({
            NSString *string = @"This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... ";
            
            NSString *linkString = @"https://www.baidu.com";
            NSArray<NSValue *> *ranges = [WCStringTool rangesOfSubstringWithString:string substring:linkString];
            
            NSMutableAttributedString *attrStringM = [[NSMutableAttributedString alloc] initWithString:string attributes:@{
                NSFontAttributeName: [UIFont systemFontOfSize:17],
            }];
            
            for (NSValue *value in ranges) {
                NSRange linkRange = [value rangeValue];
                [attrStringM addAttributes:@{
                    NSForegroundColorAttributeName: [UIColor redColor],
                    //NSBackgroundColorAttributeName: [[UIColor lightGrayColor] colorWithAlphaComponent:0.8],
                    NSLinkAttributeName: linkString,
                } range:linkRange];
            }
            
            attrStringM;
        });
        
        _label = label;
    }
    
    return _label;
}

@end
