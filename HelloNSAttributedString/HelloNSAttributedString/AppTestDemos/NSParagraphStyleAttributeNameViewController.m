//
//  NSParagraphStyleAttributeNameViewController.m
//  HelloNSAttributedString
//
//  Created by wesley chen on 16/6/14.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "NSParagraphStyleAttributeNameViewController.h"
#import "NSString+Addition.h"
#import "UIView+Addition.h"
#import "NSAttributedString+Addition.h"

#ifndef UICOLOR_RGB
#define UICOLOR_RGB(color) [UIColor colorWithRed: (((color) >> 16) & 0xFF) / 255.0 green: (((color) >> 8) & 0xFF) / 255.0 blue: ((color) & 0xFF) / 255.0 alpha: 1.0]
#endif

@interface NSParagraphStyleAttributeNameViewController ()
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;

@property (nonatomic, copy) NSString *text1;
@property (nonatomic, copy) NSString *text2;
@end

@implementation NSParagraphStyleAttributeNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.label3];
}

#pragma mark - Getters

- (UILabel *)label1 {
    if (!_label1) {
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text1 attributes:[self createDefaultAttributes]];
        
        NSArray *ranges = [self.text1 rangesOfSubstring:@"•"];
        for (NSUInteger i = 0; i < ranges.count; i++) {
            NSValue *value = (NSValue *)ranges[i];
            NSRange range = [value rangeValue];
            
            [attributedText addAttribute:NSForegroundColorAttributeName value:UICOLOR_RGB(0xFFB868) range:range];
        }
        
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, 64 + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [attributedText textSizeForMultipleLineWithWidth:label.frame.size.width];
        label.height = ceil(textSize.height);
        
        _label1 = label;
    }
    
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        NSDictionary *attributes = [self createDefaultAttributes];
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:self.text1 attributes:attributes];
        
        NSArray *ranges = [self.text1 rangesOfSubstring:@"•"];
        for (NSUInteger i = 0; i < ranges.count; i++) {
            NSValue *value = (NSValue *)ranges[i];
            NSRange range = [value rangeValue];
            [attributedText addAttribute:NSForegroundColorAttributeName value:UICOLOR_RGB(0xFFB868) range:range];
        }
        
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label1.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [label.text textSizeForMultipleLineWithWidth:label.frame.size.width attributes:attributes];
        label.height = ceil(textSize.height);
        
        _label2 = label;
    }
    return _label2;
}

- (UILabel *)label3 {
    if (!_label3) {
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label2.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        label.text = self.text2;
        label.numberOfLines = 0;
        
        CGSize textSize = [label.text textSizeForMultipleLineWithWidth:label.frame.size.width attributes:@{ NSFontAttributeName: label.font }];
        label.height = ceil(textSize.height);
        
        _label3 = label;
    }
    return _label3;
}

- (NSString *)text1 {
    if (!_text1) {
        NSString *text = @"• 此操作仅限更换手机号，不影响当前账号内容\n"
        @"• 您将使用新的手机号登录当前账号\n"
        @"• 司机联系您时，将拨打您的新手机号\n"
        @"• 司机联系您时，将拨打您的新手机号\n"
        @"• 一个月只允许更换一次手机号";
        
        _text1 = text;
    }
    
    return _text1;
}

- (NSString *)text2 {
    if (!_text2) {
        NSString *text = @"• 此操作仅限更换手机号，不影响当前账号内容"
        @"• 您将使用新的手机号登录当前账号"
        @"• 司机联系您时，将拨打您的新手机号"
        @"• 司机联系您时，将拨打您的新手机号"
        @"• 一个月只允许更换一次手机号";
        
        _text2 = text;
    }
    
    return _text2;
}

#pragma mark -

- (NSDictionary *)createDefaultAttributes {
    // @sa http://stackoverflow.com/questions/21370495/how-to-add-spacing-to-lines-in-nsattributedstring
    
    // Note: paragraph is separated by '\n'
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // Note: paragraphs' space
    paragraphStyle.paragraphSpacing = 13.0f;//0.25 * font.lineHeight;
    // Note: leading space of lines except the first line
    paragraphStyle.headIndent = 11.0f;
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName: UICOLOR_RGB(0x666666),
                                 NSBackgroundColorAttributeName: [UIColor clearColor],
                                 NSParagraphStyleAttributeName: paragraphStyle,
                                 };
    
    return attributes;
}

@end
