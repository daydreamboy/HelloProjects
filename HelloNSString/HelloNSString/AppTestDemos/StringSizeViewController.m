//
//  StringSizeViewController.m
//  HelloNSString
//
//  Created by wesley_chen on 2018/6/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "StringSizeViewController.h"
#import "WCStringTool.h"

@interface StringSizeViewController ()
@property (nonatomic, strong) UILabel *label1;
@end

@implementation StringSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label1];
}

#pragma mark - Getters

- (UILabel *)label1 {
    if (!_label1) {
        NSString *text = @"60\"";
        
        CGSize textSize = [WCStringTool textSizeWithSingleLineString:text font:[UIFont systemFontOfSize:16]];
//        CGSize textSize = [WCStringTool textSizeWithMultiLineString:text font:[UIFont systemFontOfSize:16] size:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) mode:NSLineBreakByCharWrapping];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 64 + 10, textSize.width, textSize.height)];
        label.text = text;
//        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.backgroundColor = [UIColor greenColor];
        
//        [label sizeToFit];
        
        _label1 = label;
    }
    
    return _label1;
}

@end
