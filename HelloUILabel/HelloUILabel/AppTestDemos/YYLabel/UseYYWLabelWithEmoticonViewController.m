//
//  UseYYWLabelWithEmoticonViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/7/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseYYWLabelWithEmoticonViewController.h"
#import "YYLabel.h"
#import "YYKit.h"
#import "WCImageTool.h"

#define WCCGSizeScaled(size, scale) (CGSizeMake((size).width * (scale), (size).height * (scale)))

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

@interface UseYYWLabelWithEmoticonViewController ()
@property (nonatomic, strong) YYLabel *label1;
@property (nonatomic, strong) YYLabel *label2;
@property (nonatomic, strong) YYLabel *label3;
@property (nonatomic, strong) YYLabel *label4;
@property (nonatomic, strong) YYLabel *label5;
@end

@implementation UseYYWLabelWithEmoticonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"update" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClicked:)];
    
    self.view.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:self.label1];
//    [self.view addSubview:self.label2];
    [self.view addSubview:self.label3];
//    [self.view addSubview:self.label4];
//    [self.view addSubview:self.label5];
}

#pragma mark - Actions

- (void)rightBarButtonItemClicked:(id)sender {
    NSRange range = NSMakeRange(0, self.label5.attributedText.length);
    [self.label5.attributedText enumerateAttribute:YYTextAttachmentAttributeName inRange:range options:kNilOptions usingBlock:^(YYTextAttachment *  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
        NSLog(@"%@", value);
        
        if ([value.content isKindOfClass:[UIView class]]) {
            UIView *attachmentView = (UIView *)value.content;
            attachmentView.backgroundColor = UICOLOR_randomColor;
        }
    }];
}

#pragma mark -

- (NSMutableAttributedString *)emoticonStringWithImageName:(NSString *)imageName textFont:(UIFont *)textFont emoticonCode:(NSString *)emoticonCode {
    UIImage *image = [WCImageTool imageWithName:imageName inResourceBundle:nil];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    CGSize imageViewSize = WCCGSizeScaled(imageView.bounds.size, textFont.lineHeight / imageView.bounds.size.height);
    imageView.frame = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageViewSize alignToFont:textFont alignment:YYTextVerticalAlignmentCenter];
    if (emoticonCode) {
        [attachText addAttribute:YYTextBackedStringAttributeName value:[YYTextBackedString stringWithString:emoticonCode] range:NSMakeRange(0, attachText.length)];
    }

    return attachText;
}

#pragma mark - Getters

- (YYLabel *)label1 {
    if (!_label1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString *string;
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:@""];
        NSMutableAttributedString *attrString;
        UIFont *font = [UIFont systemFontOfSize:14];
        
        string = @"This is a basketball ";
        attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : font }];
        [attrText appendAttributedString:attrString];

        // add emoticon
        [attrText appendAttributedString:[self emoticonStringWithImageName:@"dribbble64_imageio.png" textFont:font emoticonCode:@"/:^_^"]];

        string = @", and this is a smile";
        attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : font }];
        [attrText appendAttributedString:attrString];
        
        // add emoticon
        [attrText appendAttributedString:[self emoticonStringWithImageName:@"001" textFont:font emoticonCode:nil]];
        
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, 100, screenSize.width - 2 * 10, 30)];
        label.attributedText = attrText;
        
        _label1 = label;
    }
    
    return _label1;
}

- (YYLabel *)label2 {
    if (!_label2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString *string = @"This is a simile, ";
        UIFont *font = [UIFont systemFontOfSize:14];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : font }];
        
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.label1.frame) + 20, screenSize.width - 2 * 10, 30)];
        label.attributedText = attrString;
        
        _label2 = label;
    }
    
    return _label2;
}

- (YYLabel *)label3 {
    if (!_label3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString *string;
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:@""];
        NSMutableAttributedString *attrString;
        //UIFont *font = [UIFont systemFontOfSize:14];
        UIFont *font = [UIFont systemFontOfSize:43];
        
        //string = @"This is a /:^_^/:^$^/:Q/:815/:809, and test.";
        string = @"/:^_^/:^$^/:Q/:815/:809/:man/:man";
        attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : font }];
        [attrText appendAttributedString:attrString];

        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.label2.frame) + 20, screenSize.width - 2 * 10, 50)];
        label.attributedText = attrText;
        label.clipsToBounds = NO;
        
        YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
        NSMutableDictionary *mapper = [NSMutableDictionary new];
        mapper[@"/:^_^"] = [UIImage imageNamed:@"001@2x.png"];
        mapper[@"/:^$^"] = [UIImage imageNamed:@"002@2x.png"];
        mapper[@"/:Q"] = [UIImage imageNamed:@"003@2x.png"];
        mapper[@"/:815"] = [UIImage imageNamed:@"004@2x.png"];
        mapper[@"/:809"] = [UIImage imageNamed:@"005@2x.png"];
        mapper[@"/:man"] = [UIImage imageNamed:@"079@2x.png"];
        mapper[@"/:%"] = [UIImage imageNamed:@"090@2x.png"];
        parser.emoticonMapper = mapper;
        label.textParser = parser;
        
        _label3 = label;
    }
    
    return _label3;
}

- (YYLabel *)label4 {
    if (!_label4) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString *string;
        NSMutableAttributedString *attrText = [NSMutableAttributedString new];
        NSMutableAttributedString *attrString;
        UIFont *font = [UIFont systemFontOfSize:14];
        
        string = @"This is a /:^_^/:^$^/:Q/:815/:809, and test.";
        attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : font }];
        [attrText appendAttributedString:attrString];
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(100, CGFLOAT_MAX);
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attrText];
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.label3.frame) + 20, 100, 30)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.attributedText = attrText;
        CGSize textSize = layout.textBoundingSize;
        NSLog(@"textSize: %@", NSStringFromCGSize(textSize));
        label.textLayout = layout;
        
        YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
        NSMutableDictionary *mapper = [NSMutableDictionary new];
        mapper[@"/:^_^"] = [UIImage imageNamed:@"001@2x.png"];
        mapper[@"/:^$^"] = [UIImage imageNamed:@"002@2x.png"];
        mapper[@"/:Q"] = [UIImage imageNamed:@"003@2x.png"];
        mapper[@"/:815"] = [UIImage imageNamed:@"004@2x.png"];
        mapper[@"/:809"] = [UIImage imageNamed:@"005@2x.png"];
        parser.emoticonMapper = mapper;
        label.textParser = parser;
        label.frame = CGRectMake(10, CGRectGetMaxY(self.label3.frame) + 20, label.textLayout.textBoundingSize.width, label.textLayout.textBoundingSize.height);
        
        _label4 = label;
    }
    
    return _label4;
}

- (YYLabel *)label5 {
    if (!_label5) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        NSString *string;
        NSMutableAttributedString *attrText = [NSMutableAttributedString new];
        NSMutableAttributedString *attrString;
        UIFont *font = [UIFont systemFontOfSize:14];
        
        // part 1
        string = @"This is a /:^_^/:^$^/:Q/:815/:809, and test.";
        attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : font }];
        [attrText appendAttributedString:attrString];
        
        // part 2
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
        view.backgroundColor = [UIColor yellowColor];
        
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:view contentMode:UIViewContentModeCenter attachmentSize:view.bounds.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        [attachText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
        [attrText appendAttributedString:attachText];
        
//        [attrText appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
        
        // part 3
        string = @"This is a /:^_^/:^$^/:Q/:815/:809, and test.";
        attrString = [[NSMutableAttributedString alloc] initWithString:string attributes:@{ NSFontAttributeName : font }];
        [attrText appendAttributedString:attrString];
        
        YYTextContainer *container = [YYTextContainer new];
        container.size = CGSizeMake(100, CGFLOAT_MAX);
        
        YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attrText];
        YYLabel *label = [[YYLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.label3.frame) + 20, 100, 30)];
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakByCharWrapping;
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.attributedText = attrText;
        CGSize textSize = layout.textBoundingSize;
        NSLog(@"textSize: %@", NSStringFromCGSize(textSize));
        label.textLayout = layout;
        
        YYTextSimpleEmoticonParser *parser = [YYTextSimpleEmoticonParser new];
        NSMutableDictionary *mapper = [NSMutableDictionary new];
        mapper[@"/:^_^"] = [UIImage imageNamed:@"001@2x.png"];
        mapper[@"/:^$^"] = [UIImage imageNamed:@"002@2x.png"];
        mapper[@"/:Q"] = [UIImage imageNamed:@"003@2x.png"];
        mapper[@"/:815"] = [UIImage imageNamed:@"004@2x.png"];
        mapper[@"/:809"] = [UIImage imageNamed:@"005@2x.png"];
        parser.emoticonMapper = mapper;
        label.textParser = parser;
        label.frame = CGRectMake(10, CGRectGetMaxY(self.label4.frame) + 20, 100, label.textLayout.textBoundingSize.height);
        
        _label5 = label;
    }
    
    return _label5;
}

@end
