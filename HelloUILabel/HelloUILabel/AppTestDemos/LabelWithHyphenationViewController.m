//
//  LabelWithHyphenationViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/23.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "LabelWithHyphenationViewController.h"
#import "WCMacroTool.h"
#import "WCStringTool.h"

@interface LabelWithHyphenationViewController ()
@property (nonatomic, strong) UILabel *labelWithHyphenation;
@property (nonatomic, strong) UILabel *labelWithSoftHyphenation;
@end

@implementation LabelWithHyphenationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.labelWithHyphenation];
    [self.view addSubview:self.labelWithSoftHyphenation];
}

#pragma mark - Getters

- (UILabel *)labelWithHyphenation {
    if (!_labelWithHyphenation) {
        NSString *string = @"Do any additional setup after loading the view. Do any additional setup after loading the view.";
        
        // @see https://stackoverflow.com/a/19414663
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.hyphenationFactor = 1;
        
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
        attrs[NSParagraphStyleAttributeName] = paragraphStyle;
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:string attributes:attrs];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 60 + 10, 100, 200)];
        label.numberOfLines = 0;
        label.attributedText = attrString;
        label.backgroundColor = [UIColor yellowColor];
        
        _labelWithHyphenation = label;
    }
    
    return _labelWithHyphenation;
}

- (UILabel *)labelWithSoftHyphenation {
    if (!_labelWithSoftHyphenation) {
        NSString *string = @"Do any additional setup after loading the view. Do any additional setup after loading the view.";
        
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"en_US"];
        
        NSError *error;
        NSString *hyphenatedString = [WCStringTool softHyphenatedStringWithString:string locale:locale error:&error];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.labelWithHyphenation.frame) + 10, 100, 200)];
        label.numberOfLines = 0;
        label.text = hyphenatedString;
        label.font = [UIFont systemFontOfSize:14];
        label.backgroundColor = [UIColor yellowColor];
        
        _labelWithSoftHyphenation = label;
    }
    
    return _labelWithSoftHyphenation;
}

@end
