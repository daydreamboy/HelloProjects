//
//  AttributedStringWithImageViewController.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 17/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "AttributedStringWithImageViewController.h"
#import "NSAttributedString+Addition.h"
#import "UIView+Addition.h"
#import "WCAttributedStringTool.h"

@interface AttributedStringWithImageViewController ()
@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@end

@implementation AttributedStringWithImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
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

#pragma mark -

- (NSAttributedString *)createAttributeString1 {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"like<img1>after<img2>"];
    
    NSAttributedString *attrStringWithImage1 = [self attributedStringWithImageName:@"img1.jpg" frame:CGRectMake(0, 0, 30, 30)];
    NSRange range1 = [attributedString.string rangeOfString:@"<img1>"];
    [attributedString replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];

    NSAttributedString *attrStringWithImage2 = [self attributedStringWithImageName:@"img2.png" frame:CGRectMake(100, 10, 30, 30)];
    NSRange range2 = [attributedString.string rangeOfString:@"<img2>"];
    [attributedString replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
    
    return attributedString;
}

- (NSAttributedString *)createAttributeString2 {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"like<img1>after<img2>"];
    
    NSAttributedString *attrStringWithImage1 = [self attributedStringWithImageName:@"img1.jpg" frame:CGRectMake(-100, -20, 30, 30)];
    NSRange range1 = [attributedString.string rangeOfString:@"<img1>"];
    [attributedString replaceCharactersInRange:range1 withAttributedString:attrStringWithImage1];
    
    NSAttributedString *attrStringWithImage2 = [self attributedStringWithImageName:@"img2.png" frame:CGRectMake(100, 10, 30, 30)];
    NSRange range2 = [attributedString.string rangeOfString:@"<img2>"];
    [attributedString replaceCharactersInRange:range2 withAttributedString:attrStringWithImage2];
    
    return attributedString;
}

- (NSAttributedString *)attributedStringWithImageName:(NSString *)imageName frame:(CGRect)frame {
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    textAttachment.image = [UIImage imageNamed:imageName];
    // Note: bounds consider baseline, and ignore x, only conside y/width/height, y is upward
    textAttachment.bounds = frame;
    
    NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    return attrStringWithImage;
}

@end
