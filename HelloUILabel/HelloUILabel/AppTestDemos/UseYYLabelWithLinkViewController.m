//
//  UseYYLabelWithLinkViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/7/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseYYLabelWithLinkViewController.h"
#import "YYLabel.h"


@interface UseYYLabelWithLinkViewController ()
@property (nonatomic, strong) YYLabel *label1;
@end

@implementation UseYYLabelWithLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label1];
}

#pragma mark - Getters

- (YYLabel *)label1 {
    if (!_label1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString *string = @"This is a link, www.baidu.com. Tap to open it.";
        NSRange range = [string rangeOfString:@"www.baidu.com"];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string];
        
        [attrString yy_setTextHighlightRange:range
                                 color:[UIColor blueColor]
                       backgroundColor:nil//[UIColor lightGrayColor]
                             tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                 NSLog(@"tap text range:...");
                             }];
        
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, 100, screenSize.width - 2 * 10, 30)];
        label.attributedText = attrString;
        
        _label1 = label;
    }
    
    return _label1;
}

@end
