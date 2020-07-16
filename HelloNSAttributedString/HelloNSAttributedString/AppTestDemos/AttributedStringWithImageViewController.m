//
//  AttributedStringWithImageViewController.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 17/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "AttributedStringWithImageViewController.h"
#import "UIView+Addition.h"
#import "WCAttributedStringTool.h"

@interface AttributedStringWithImageViewController ()
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UILabel *label5;
@property (nonatomic, strong) UILabel *label6;
@end

@implementation AttributedStringWithImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.label3];
    [self.view addSubview:self.label4];
    [self.view addSubview:self.label5];
    [self.view addSubview:self.label6];
}

#pragma mark - Getters

- (UILabel *)label1 {
    if (!_label1) {
        
        NSAttributedString *attributedText = [self createAttributeString1];
        
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, 64 + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        _label1 = label;
    }
    
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        
        NSAttributedString *attributedText = [self createAttributeString2];
        
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label1.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
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
        
        UIFont *font = [UIFont systemFontOfSize:17];
        NSAttributedString *attributedText = [self createAttributeString3WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        _label3 = label;
    }
    
    return _label3;
}

- (UILabel *)label4 {
    if (!_label4) {
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label3.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        
        UIFont *font = [UIFont systemFontOfSize:14];
        NSAttributedString *attributedText = [self createAttributeString4WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        _label4 = label;
    }
    
    return _label4;
}

- (UILabel *)label5 {
    if (!_label5) {
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label4.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        
        UIFont *font = [UIFont systemFontOfSize:32];
        NSAttributedString *attributedText = [self createAttributeString5WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        _label5 = label;
    }
    
    return _label5;
}

- (UILabel *)label6 {
    if (!_label6) {
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label5.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        
        UIFont *font = [UIFont systemFontOfSize:32];
        NSAttributedString *attributedText = [self createAttributeString6WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        _label6 = label;
    }
    
    return _label6;
}

#pragma mark -

- (NSAttributedString *)createAttributeString1 {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"like<img1>after<img2>"];
    
    NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"img1.jpg" frame:CGRectMake(0, 0, 30, 30)];
    NSRange range1 = [attributedString.string rangeOfString:@"<img1>"];
    [attributedString replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];

    NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"img2.png" frame:CGRectMake(100, 10, 30, 30)];
    NSRange range2 = [attributedString.string rangeOfString:@"<img2>"];
    [attributedString replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
    
    return attributedString;
}

- (NSAttributedString *)createAttributeString2 {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"like<img1>after<img2>"];
    
    NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"img1.jpg" frame:CGRectMake(-100, -20, 30, 30)];
    NSRange range1 = [attributedString.string rangeOfString:@"<img1>"];
    [attributedString replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];
    
    NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"img2.png" frame:CGRectMake(100, 10, 30, 30)];
    NSRange range2 = [attributedString.string rangeOfString:@"<img2>"];
    [attributedString replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
    
    return attributedString;
}

- (NSAttributedString *)createAttributeString3WithFont:(UIFont *)font {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"likej<img1>aftery<img2>"];
    
    NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"img1.jpg" imageSize:CGSizeZero alignToFont:font];
    NSRange range1 = [attributedString.string rangeOfString:@"<img1>"];
    [attributedString replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];
    
    NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"img2.png" imageSize:CGSizeZero alignToFont:font];
    NSRange range2 = [attributedString.string rangeOfString:@"<img2>"];
    [attributedString replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
    
    [attributedString addAttributes:@{ NSFontAttributeName: font } range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}

- (NSAttributedString *)createAttributeString4WithFont:(UIFont *)font {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"中文<img1>你好<img2>"];

    NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"img1.jpg" imageSize:CGSizeZero alignToFont:font];
    NSRange range1 = [attributedString.string rangeOfString:@"<img1>"];
    [attributedString replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];

    NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"img2.png" imageSize:CGSizeZero alignToFont:font];
    NSRange range2 = [attributedString.string rangeOfString:@"<img2>"];
    [attributedString replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];

    [attributedString addAttributes:@{ NSFontAttributeName: font } range:NSMakeRange(0, attributedString.length)];

    return attributedString;
}

- (NSAttributedString *)createAttributeString5WithFont:(UIFont *)font {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"中文<img1>你好<img2>"];
    
    NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"icon1" imageSize:CGSizeZero alignToFont:font];
    NSRange range1 = [attributedString.string rangeOfString:@"<img1>"];
    [attributedString replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];
    
    NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"icon1" imageSize:CGSizeMake(10, 10) alignToFont:font];
    NSRange range2 = [attributedString.string rangeOfString:@"<img2>"];
    [attributedString replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
    
    [attributedString addAttributes:@{ NSFontAttributeName: font } range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}

- (NSAttributedString *)createAttributeString6WithFont:(UIFont *)font {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"中文<img1>你好<img2>"];
    
    NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"icon1" imageSize:CGSizeZero alignToFont:font];
    NSRange range1 = [attributedString.string rangeOfString:@"<img1>"];
    [attributedString replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];
    
    NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"icon1" imageSize:CGSizeMake(60, 60) alignToFont:font];
    NSRange range2 = [attributedString.string rangeOfString:@"<img2>"];
    [attributedString replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
    
    [attributedString addAttributes:@{ NSFontAttributeName: font } range:NSMakeRange(0, attributedString.length)];
    
    return attributedString;
}

@end
