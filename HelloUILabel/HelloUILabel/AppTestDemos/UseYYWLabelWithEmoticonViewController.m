//
//  UseYYWLabelWithEmoticonViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2018/7/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseYYWLabelWithEmoticonViewController.h"
#import "YYLabel.h"

CGSize WCCGSizeScaled(CGSize size, CGFloat scale)
{
    if (scale < 0) {
        return size;
    }
    CGSize newSize = CGSizeMake(size.width * scale, size.height * scale);
    return newSize;
}

@interface UseYYWLabelWithEmoticonViewController ()
@property (nonatomic, strong) YYLabel *label1;
@property (nonatomic, strong) YYLabel *label2;
@end

@implementation UseYYWLabelWithEmoticonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label1];
    [self.view addSubview:self.label2];
}

- (NSMutableAttributedString *)emoticonStringWithImageName:(NSString *)imageName textFont:(UIFont *)textFont emoticonCode:(NSString *)emoticonCode {
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[self.class imageWithFileName:imageName]];
    CGSize imageViewSize = WCCGSizeScaled(imageView.bounds.size, textFont.lineHeight / imageView.bounds.size.height);
    imageView.frame = CGRectMake(0, 0, imageViewSize.width, imageViewSize.height);
    
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:imageView contentMode:UIViewContentModeCenter attachmentSize:imageViewSize alignToFont:textFont alignment:YYTextVerticalAlignmentCenter];
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


#pragma mark -

+ (UIImage *)imageWithFileName:(NSString *)fileName {
    return [self imageWithFileName:fileName inBundle:nil];
}

+ (UIImage *)imageWithFileName:(NSString *)fileName inBundle:(NSString *)bundleName {
    NSString *resourceBundlePath = [NSBundle mainBundle].bundlePath;
    if (bundleName) {
        resourceBundlePath = [resourceBundlePath stringByAppendingPathComponent:[bundleName stringByAppendingPathExtension:@"bundle"]];
    }
    
    if (!fileName.pathExtension.length) {
        fileName = [NSString stringWithFormat:@"%@@%dx.png", fileName, (int)[UIScreen mainScreen].scale];
    }
    
    NSString *filePath = [resourceBundlePath stringByAppendingPathComponent:fileName];
    return [UIImage imageWithContentsOfFile:filePath];
}

@end
