//
//  LabelWithMaximumLinesViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/14.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "LabelWithMaximumLinesViewController.h"
#import "WCStringTool.h"
#import "YYLabel.h"

@interface LabelWithMaximumLinesViewController ()
@property (nonatomic, strong) UILabel *labelWithAutoLineNumber;
@property (nonatomic, strong) UILabel *labelWithFixedLineNumber;
@property (nonatomic, strong) YYLabel *yyLabel;
@end

@implementation LabelWithMaximumLinesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.labelWithAutoLineNumber];
    [self.view addSubview:self.labelWithFixedLineNumber];
    [self.view addSubview:self.yyLabel];
}

#pragma mark - Getters

- (UILabel *)labelWithAutoLineNumber {
    if (!_labelWithAutoLineNumber) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        label.text = @"a long long long long long long long long long long long long text";
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.font = [UIFont systemFontOfSize:14];
        label.numberOfLines = 0;
        label.backgroundColor = [UIColor yellowColor];
        
        CGSize textSize = [WCStringTool textSizeWithMultipleLineString:label.text width:100 font:label.font mode:label.lineBreakMode widthToFit:YES];
        NSLog(@"%@", NSStringFromCGSize(textSize));
        
        label.frame = CGRectMake(10, 80, textSize.width, textSize.height);
        
        _labelWithAutoLineNumber = label;
    }
    
    return _labelWithAutoLineNumber;
}

- (UILabel *)labelWithFixedLineNumber {
    if (!_labelWithFixedLineNumber) {
        NSString *string = @"a long long long long long long long long long long long long text";
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        UIFont *font = [UIFont systemFontOfSize:14];
        //label.text = string;
//        label.lineBreakMode = NSLineBreakByTruncatingTail;
//        label.font = font;
        label.numberOfLines = 2;
        label.backgroundColor = [UIColor yellowColor];
        
        NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        paragraphStyle.hyphenationFactor = 1.0;
        
        NSMutableDictionary *attr = [NSMutableDictionary dictionary];
        attr[NSParagraphStyleAttributeName] = paragraphStyle;
        attr[NSFontAttributeName] = font;
        
        label.attributedText = [[NSMutableAttributedString alloc] initWithString:string attributes:attr];
        
        CGSize textSize = [WCStringTool textSizeWithFixedLineString:label.text width:100 font:label.font numberOfLines:label.numberOfLines mode:label.lineBreakMode widthToFit:YES];
        NSLog(@"%@", NSStringFromCGSize(textSize));
        
        label.frame = CGRectMake(10, CGRectGetMaxY(self.labelWithAutoLineNumber.frame) + 10, textSize.width, textSize.height);
        
        _labelWithFixedLineNumber = label;
    }
    
    return _labelWithFixedLineNumber;
}

- (YYLabel *)yyLabel {
    if (!_yyLabel) {
        // @see https://www.jianshu.com/p/24148edec6c2
        NSString *content = @"a long long long long long long long long long long long long text";
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.labelWithFixedLineNumber.frame) + 10, 100, 50)];
        label.backgroundColor = [UIColor yellowColor];
        
        label.truncationToken = [[NSAttributedString alloc] initWithString:@"..."];
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.numberOfLines = 2;
        
        NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:content];
        text.yy_font = [UIFont systemFontOfSize:14];
        text.yy_lineBreakMode = NSLineBreakByCharWrapping;
        
        CGSize textSize = [WCStringTool textSizeWithFixedLineString:content width:100 font:text.yy_font numberOfLines:label.numberOfLines mode:text.yy_lineBreakMode widthToFit:YES];
        
        label.frame = CGRectMake(10, CGRectGetMaxY(self.labelWithFixedLineNumber.frame) + 10, 100, textSize.height);
        
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(100, textSize.height)];
        container.truncationType = YYTextTruncationTypeEnd;
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:text];
        
        label.textLayout = layout;
        
        _yyLabel = label;
    }
    
    return _yyLabel;
}

@end
