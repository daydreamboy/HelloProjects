//
//  TextAlignmentViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/11/28.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "TextAlignmentViewController.h"

@interface TextAlignmentViewController ()
@property (nonatomic, strong) UILabel *labelDefault;
@property (nonatomic, strong) UILabel *labelLeft;
@property (nonatomic, strong) UILabel *labelCenter;
@property (nonatomic, strong) UILabel *labelRight;
@property (nonatomic, strong) UILabel *labelJustified;
@property (nonatomic, strong) UILabel *labelNatural;
@property (nonatomic, strong) UILabel *labelParagraphJustified;
@end

@implementation TextAlignmentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.labelDefault];
    [self.view addSubview:self.labelLeft];
    [self.view addSubview:self.labelCenter];
    [self.view addSubview:self.labelRight];
    [self.view addSubview:self.labelJustified];
    [self.view addSubview:self.labelNatural];
    [self.view addSubview:self.labelParagraphJustified];
}

#pragma mark - Getters

- (UILabel *)labelDefault {
    if (!_labelDefault) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 80, screenSize.width - 20, 60)];
        label.text = @"a long long long text";
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor yellowColor];
        
        _labelDefault = label;
    }
    
    return _labelDefault;
}

- (UILabel *)labelLeft {
    if (!_labelLeft) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelDefault.frame) + 10, screenSize.width - 20, 60)];
        label.text = @"a long long long text";
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentLeft;
        label.backgroundColor = [UIColor yellowColor];
        
        _labelLeft = label;
    }
    
    return _labelLeft;
}

- (UILabel *)labelCenter {
    if (!_labelCenter) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelLeft.frame) + 10, screenSize.width - 20, 60)];
        label.text = @"a long long long text";
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor yellowColor];
        
        _labelCenter = label;
    }
    
    return _labelCenter;
}

- (UILabel *)labelRight {
    if (!_labelRight) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelCenter.frame) + 10, screenSize.width - 20, 60)];
        label.text = @"a long long long text";
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentRight;
        label.backgroundColor = [UIColor yellowColor];
        
        _labelRight = label;
    }
    
    return _labelRight;
}

- (UILabel *)labelJustified {
    if (!_labelJustified) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelRight.frame) + 10, screenSize.width - 20, 60)];
        label.text = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt.";
        label.numberOfLines = 0;
        label.textAlignment = NSTextAlignmentJustified;
        label.backgroundColor = [UIColor yellowColor];
        
        _labelJustified = label;
    }
    
    return _labelJustified;
}

- (UILabel *)labelNatural {
    if (!_labelNatural) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelJustified.frame) + 10, screenSize.width - 20, 60)];
        label.text = @"اليوم الحاضر";
        label.numberOfLines = 0;
        // Note: to make NSTextAlignmentNatural effective,
        // open Scheme -> Options -> Application Language, change it to `Right-to-Left Pseudolanguage`
        label.textAlignment = NSTextAlignmentNatural;
        label.backgroundColor = [UIColor yellowColor];
        
        _labelNatural = label;
    }
    
    return _labelNatural;
}

- (UILabel *)labelParagraphJustified {
    if (!_labelParagraphJustified) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        // @see https://stackoverflow.com/a/27060631
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.alignment = NSTextAlignmentJustified;
        
        NSDictionary *attrs = @{
                                NSParagraphStyleAttributeName: paragraphStyle,
                                NSBaselineOffsetAttributeName: @0,
                                };
        
        NSString *plainString = @"Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt.";
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:plainString attributes:attrs];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.labelNatural.frame) + 10, screenSize.width - 20, 60)];
        label.attributedText = attrString;
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor yellowColor];
        
        _labelParagraphJustified = label;
    }
    
    return _labelParagraphJustified;
}

@end
