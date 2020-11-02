//
//  ShowLinkWithWCLabelViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/11/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "ShowLinkWithWCLabelViewController.h"
#import "WCLabel.h"
#import "WCStringTool.h"

@interface ShowLinkWithWCLabelViewController ()
@property (nonatomic, strong) WCLabel *label;
@end

@implementation ShowLinkWithWCLabelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label];
}

#pragma mark - Getter

- (WCLabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCLabel *label = [[WCLabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 300)];
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
