//
//  UseDynamicFontToGetViewController.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseDynamicFontToGetViewController.h"
#import "WCDynamicFontManager.h"

@interface UseDynamicFontToGetViewController ()
@property (nonatomic, strong) UILabel *labelBody;
@end

@implementation UseDynamicFontToGetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelBody];
    
    WCSetDynamicFont(self.labelBody, @"label_body", [UIFont systemFontOfSize:15], ^(id object, UIFont *newFont) {
        NSLog(@"%@", newFont);
        UILabel *label = (UILabel *)object;
        CGRect frame = label.frame;
        [label sizeToFit];
        CGRect textBounds = label.bounds;
        frame.size.width = CGRectGetWidth(textBounds);
        frame.size.height = CGRectGetHeight(textBounds);
        
        label.frame = frame;
    });
}

#pragma mark - Getter

- (UILabel *)labelBody {
    if (!_labelBody) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screenSize.width, 30)];
        label.layer.borderColor = [UIColor orangeColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Hello, 你好!";
        
        _labelBody = label;
    }
    
    return _labelBody;
}

@end
