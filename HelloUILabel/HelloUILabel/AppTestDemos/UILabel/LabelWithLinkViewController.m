//
//  LabelWithLinkViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/10/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "LabelWithLinkViewController.h"
#import "WCLabelTool.h"
#import "WCStringTool.h"

@interface LabelWithLinkViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation LabelWithLinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label];
}

#pragma mark - Getter

- (UILabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat width = screenSize.width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 300)];
        label.numberOfLines = 0;
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.text = @"This is a link www.baidu1.com, blah, blah, blah, blah, blah, blah, blah, blah...This is a link www.baidu2.com, blah, blah, blah, blah...This is a link www.baidu3.com, blah, blah, blah, blah...This is a link www.baidu4.com, blah, blah, blah, blah...";
        label.userInteractionEnabled = YES;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        CGSize textSize = [WCStringTool textSizeWithMultipleLineString:label.text width:width font:label.font mode:label.lineBreakMode widthToFit:YES];
        label.frame = ({
            CGRect frame = label.frame;
            frame.size.height = textSize.height;
            frame.size.width = textSize.width;
            frame;
        });
        
        //[label sizeThatFits:CGSizeMake(screenSize.width, CGFLOAT_MAX)];
        
        [WCLabelTool addLinkDetectionWithLabel:label linkColor:[UIColor blueColor] linkTapBlock:^(UILabel * _Nonnull label, NSRange linkRange, id  _Nonnull userInfo) {
            NSString *linkString = [label.text substringWithRange:linkRange];
            NSLog(@"%@", linkString);
        } userInfo:nil forceReplace:NO];
        
        _label = label;
    }
    
    return _label;
}

@end
