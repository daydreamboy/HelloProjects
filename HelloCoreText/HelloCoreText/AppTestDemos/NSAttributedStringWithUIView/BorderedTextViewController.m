//
//  BorderedTextViewController.m
//  HelloCoreText
//
//  Created by wesley_chen on 14/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "BorderedTextViewController.h"
#import "BorderedTextView.h"

@interface BorderedTextViewController ()

@end

@implementation BorderedTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    NSTextBorder *border = [NSTextBorder new];
    border.width = 1;
    border.radius = 10;
    border.paddings = UIEdgeInsetsMake(5, 5, 5, 5);
    
    NSString *string = @"Hello, Hworldyjp";
    NSRange borderedRange = [string rangeOfString:@"Hworldyjp"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    
    NSDictionary *attrs = @{
                            NSForegroundColorAttributeName: [UIColor greenColor],
                            NSFontAttributeName: [UIFont systemFontOfSize:30],
                            };
    
    [attributedString addAttributes:@{ NSBorderAttributeName: border } range:borderedRange];
    [attributedString addAttributes:attrs range:NSMakeRange(0, string.length)];
    
    BorderedTextView *view = [[BorderedTextView alloc] initWithFrame:CGRectMake(20, 64, 300, 60)];
    view.attrString = attributedString;
    view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    
    [self.view addSubview:view];
}

@end
