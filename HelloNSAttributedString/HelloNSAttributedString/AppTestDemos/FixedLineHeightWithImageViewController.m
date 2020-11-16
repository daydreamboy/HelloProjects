//
//  FixedLineHeightWithImageViewController.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2020/11/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "FixedLineHeightWithImageViewController.h"
#import "WCAttributedStringTool.h"
#import "UIView+Addition.h"

@interface FixedLineHeightWithImageViewController ()
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;
@property (nonatomic, strong) UILabel *label4;
@property (nonatomic, strong) UILabel *label5;
@property (nonatomic, strong) UILabel *label6;
@property (nonatomic, strong) UILabel *label7;
@property (nonatomic, strong) UILabel *label8;
@property (nonatomic, strong) UILabel *label9;
@property (nonatomic, strong) UILabel *label10;
@property (nonatomic, strong) UILabel *label11;
@end

@implementation FixedLineHeightWithImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
    [self.view addSubview:self.label3];
    [self.view addSubview:self.label4];
    [self.view addSubview:self.label5];
    [self.view addSubview:self.label6];
    [self.view addSubview:self.label7];
    [self.view addSubview:self.label8];
    [self.view addSubview:self.label9];
    [self.view addSubview:self.label10];
    [self.view addSubview:self.label11];
}

#pragma mark - Getters

- (UILabel *)label1 {
    if (!_label1) {
        
        NSAttributedString *attributedText = [self createAttributedString1];
        
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, startY + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:1 widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        NSAssert(CGSizeEqualToSize(textSize, textSize2), @"not pass");
        
        _label1 = label;
    }
    
    return _label1;
}

- (UILabel *)label2 {
    if (!_label2) {
        
        NSAttributedString *attributedText = [self createAttributedString2];
        
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label1.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:1 widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        NSAssert(CGSizeEqualToSize(textSize, textSize2), @"not pass");
        
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
        NSAttributedString *attributedText = [self createAttributedString3WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:1 widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        NSAssert(CGSizeEqualToSize(textSize, textSize2), @"not pass");
        
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
        NSAttributedString *attributedText = [self createAttributedString4WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:1 widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        NSAssert(CGSizeEqualToSize(textSize, textSize2), @"not pass");
        
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
        NSAttributedString *attributedText = [self createAttributedString5WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:1 widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        NSAssert(CGSizeEqualToSize(textSize, textSize2), @"not pass");
        
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
        NSAttributedString *attributedText = [self createAttributedString6WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:label.numberOfLines widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        NSAssert(CGSizeEqualToSize(textSize, textSize2), @"not pass");
        
        _label6 = label;
    }
    
    return _label6;
}

- (UILabel *)label7 {
    if (!_label7) {
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label6.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        
        UIFont *font = [UIFont systemFontOfSize:32];
        NSAttributedString *attributedText = [self createAttributedString7WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:label.numberOfLines widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        label.height = textSize2.height;
        NSAssert(CGSizeEqualToSize(textSize, textSize2), @"not pass");
        
        _label7 = label;
    }
    
    return _label7;
}

- (UILabel *)label8 {
    if (!_label8) {
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label7.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        
        UIFont *font = [UIFont systemFontOfSize:32];
        NSAttributedString *attributedText = [self createAttributedString7WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 1;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:label.numberOfLines widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        label.height = textSize2.height;
        
        _label8 = label;
    }
    
    return _label8;
}

- (UILabel *)label9 {
    if (!_label9) {
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label8.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        
        UIFont *font = [UIFont systemFontOfSize:32];
        NSAttributedString *attributedText = [self createAttributedString7WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 2;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:label.numberOfLines widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        label.height = textSize2.height;
        NSAssert(CGSizeEqualToSize(textSize, textSize2), @"not pass");
        
        _label9 = label;
    }
    
    return _label9;
}

- (UILabel *)label10 {
    if (!_label10) {
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label9.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        
        UIFont *font = [UIFont systemFontOfSize:32];
        NSAttributedString *attributedText = [self createAttributedString8WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 0;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:label.numberOfLines widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        label.height = textSize2.height;
        NSAssert(CGSizeEqualToSize(textSize, textSize2), @"not pass");
        
        _label10 = label;
    }
    
    return _label10;
}

- (UILabel *)label11 {
    if (!_label11) {
        CGFloat paddingH = 19;
        CGFloat width = 280 - 2 * paddingH;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.label10.frame) + 5, width, 0)];
        label.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8];
        
        UIFont *font = [UIFont systemFontOfSize:32];
        NSAttributedString *attributedText = [self createAttributedString8WithFont:font];
        
        label.attributedText = attributedText;
        label.numberOfLines = 3;
        
        CGSize textSize = [WCAttributedStringTool textSizeWithMultipleLineAttributedString:attributedText width:label.frame.size.width widthToFit:NO];
        label.height = textSize.height;
        
        CGSize textSize2 = [WCAttributedStringTool textSizeWithFixedLineAttributedString:attributedText width:label.frame.size.width maximumNumberOfLines:label.numberOfLines widthToFit:NO];
        NSLog(@"%@", NSStringFromCGSize(textSize2));
        label.height = textSize2.height;
        //NSAssert(CGSizeEqualToSize(textSize, textSize2), @"not pass");
        
        _label11 = label;
    }
    
    return _label11;
}

#pragma mark -

- (NSAttributedString *)createAttributedString1 {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"like<img1>after<img2>"];
    
    NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"img1.jpg" frame:CGRectMake(0, 0, 30, 30)];
    NSRange range1 = [attributedString.string rangeOfString:@"<img1>"];
    [attributedString replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];

    NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"img2.png" frame:CGRectMake(100, 10, 30, 30)];
    NSRange range2 = [attributedString.string rangeOfString:@"<img2>"];
    [attributedString replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
    
    return attributedString;
}

- (NSAttributedString *)createAttributedString2 {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"like<img1>after<img2>"];
    
    NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"img1.jpg" frame:CGRectMake(-100, -20, 30, 30)];
    NSRange range1 = [attributedString.string rangeOfString:@"<img1>"];
    [attributedString replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];
    
    NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"img2.png" frame:CGRectMake(100, 10, 30, 30)];
    NSRange range2 = [attributedString.string rangeOfString:@"<img2>"];
    [attributedString replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
    
    return attributedString;
}

- (NSAttributedString *)createAttributedString3WithFont:(UIFont *)font {
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

- (NSAttributedString *)createAttributedString4WithFont:(UIFont *)font {
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

- (NSAttributedString *)createAttributedString5WithFont:(UIFont *)font {
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

- (NSAttributedString *)createAttributedString6WithFont:(UIFont *)font {
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

- (NSAttributedString *)createAttributedString7WithFont:(UIFont *)font {
    NSMutableAttributedString *attributedString1 = ({
        NSMutableAttributedString *attributedStringM = [[NSMutableAttributedString alloc] initWithString:@"中文<img1>你好<img2>"];
        NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"icon1" imageSize:CGSizeZero alignToFont:font];
        NSRange range1 = [attributedStringM.string rangeOfString:@"<img1>"];
        [attributedStringM replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];

        NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"icon1" imageSize:CGSizeMake(60, 60) alignToFont:font];
        NSRange range2 = [attributedStringM.string rangeOfString:@"<img2>"];
        [attributedStringM replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];

        [attributedStringM addAttributes:@{ NSFontAttributeName: font } range:NSMakeRange(0, attributedStringM.length)];
        attributedStringM;
    });
    
    NSMutableAttributedString *attributedString2 = ({
        NSMutableAttributedString *attributedStringM = [[NSMutableAttributedString alloc] initWithString:@"likej<img1>aftery<img2>"];
        
        NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"img1.jpg" imageSize:CGSizeZero alignToFont:font];
        NSRange range1 = [attributedStringM.string rangeOfString:@"<img1>"];
        [attributedStringM replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];
        
        NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"img2.png" imageSize:CGSizeZero alignToFont:font];
        NSRange range2 = [attributedStringM.string rangeOfString:@"<img2>"];
        [attributedStringM replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
        
        [attributedStringM addAttributes:@{ NSFontAttributeName: font } range:NSMakeRange(0, attributedStringM.length)];
        
        attributedStringM;
    });
    
    [attributedString1 appendAttributedString:attributedString2];
    
    return attributedString1;
}

- (NSAttributedString *)createAttributedString8WithFont:(UIFont *)font {
    NSMutableAttributedString *attributedString1 = ({
        NSMutableAttributedString *attributedStringM = [[NSMutableAttributedString alloc] initWithString:@"中文<img1>你好<img2>"];
        NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"icon1" imageSize:CGSizeZero alignToFont:font];
        NSRange range1 = [attributedStringM.string rangeOfString:@"<img1>"];
        [attributedStringM replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];

        NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"icon1" imageSize:CGSizeMake(60, 60) alignToFont:font];
        NSRange range2 = [attributedStringM.string rangeOfString:@"<img2>"];
        [attributedStringM replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];

        [attributedStringM addAttributes:@{ NSFontAttributeName: font } range:NSMakeRange(0, attributedStringM.length)];
        attributedStringM;
    });
    
    NSMutableAttributedString *attributedString2 = ({
        NSMutableAttributedString *attributedStringM = [[NSMutableAttributedString alloc] initWithString:@"likej<img1>aftery<img2>"];
        
        NSAttributedString *attrStringWithImage1 = [WCAttributedStringTool attributedStringWithImageName:@"img1.jpg" imageSize:CGSizeZero alignToFont:font];
        NSRange range1 = [attributedStringM.string rangeOfString:@"<img1>"];
        [attributedStringM replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];
        
        NSAttributedString *attrStringWithImage2 = [WCAttributedStringTool attributedStringWithImageName:@"img2.png" imageSize:CGSizeZero alignToFont:font];
        NSRange range2 = [attributedStringM.string rangeOfString:@"<img2>"];
        [attributedStringM replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
        
        [attributedStringM addAttributes:@{ NSFontAttributeName: font } range:NSMakeRange(0, attributedStringM.length)];
        
        attributedStringM;
    });
    
    [attributedString1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    [attributedString1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"abc"]];
    [attributedString1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    [attributedString1 appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    
    [attributedString1 appendAttributedString:attributedString2];
    
    return attributedString1;
}

@end
