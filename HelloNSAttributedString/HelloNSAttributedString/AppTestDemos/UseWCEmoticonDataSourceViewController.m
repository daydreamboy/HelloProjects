//
//  UseWCEmoticonDataSourceViewController.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2020/11/17.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseWCEmoticonDataSourceViewController.h"
#import "WCEmoticonDataSource.h"
#import "WCAttributedStringTool.h"
#import "UIView+Addition.h"

@interface UseWCEmoticonDataSourceViewController ()
@property (nonatomic, strong) UILabel *labelEmoticon1;
@property (nonatomic, strong) UILabel *labelEmoticon2;
@property (nonatomic, strong) UILabel *labelEmoticon3;
@property (nonatomic, strong) UILabel *labelEmoticon4;
@property (nonatomic, strong) UILabel *labelEmoticon5;
@end

@implementation UseWCEmoticonDataSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.labelEmoticon1];
    [self.view addSubview:self.labelEmoticon2];
    [self.view addSubview:self.labelEmoticon3];
    [self.view addSubview:self.labelEmoticon4];
    [self.view addSubview:self.labelEmoticon5];
}

#pragma mark - Getter

- (UILabel *)labelEmoticon1 {
    if (!_labelEmoticon1) {
        NSString *text = @"这是一个微笑表情[微笑]，还有其他表情[开心][可爱][睡][色][闭嘴]"; // [送花花][比心]
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17],
        };
        
        CGFloat width = 280;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, startY + 10, width, 0)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 0;
        label.attributedText = [[WCEmoticonDataSource sharedInstance] emoticonizedStringWithString:text attributes:attrs];
        CGSize textSize = [WCAttributedStringTool textSizeWithFixedLineAttributedString:label.attributedText width:width maximumNumberOfLines:label.numberOfLines forceUseFixedLineHeight:NO widthToFit:NO];
        label.height = textSize.height;
        
        _labelEmoticon1 = label;
    }
    
    return _labelEmoticon1;
}

- (UILabel *)labelEmoticon2 {
    if (!_labelEmoticon2) {
        NSString *text = @"这是一个微笑表情[微笑]，还有其他表情[开心][可爱][睡][色][闭嘴]"; // [送花花][比心]
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17],
        };
        
        CGFloat width = 280;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_labelEmoticon1.frame) + 10, width, 0)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 2;
        label.attributedText = [[WCEmoticonDataSource sharedInstance] emoticonizedStringWithString:text attributes:attrs];
        CGSize textSize = [WCAttributedStringTool textSizeWithFixedLineAttributedString:label.attributedText width:width maximumNumberOfLines:label.numberOfLines forceUseFixedLineHeight:NO widthToFit:NO];
        label.height = textSize.height;
        
        _labelEmoticon2 = label;
    }
    
    return _labelEmoticon2;
}

- (UILabel *)labelEmoticon3 {
    if (!_labelEmoticon3) {
        NSString *text = @"这是一个微笑表情[微笑]，还有其他表情[开心][可爱][睡][色][闭嘴]"; // [送花花][比心]
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17],
        };
        
        CGFloat width = 280;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_labelEmoticon2.frame) + 10, width, 0)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 1;
        label.attributedText = [[WCEmoticonDataSource sharedInstance] emoticonizedStringWithString:text attributes:attrs];
        CGSize textSize = [WCAttributedStringTool textSizeWithFixedLineAttributedString:label.attributedText width:width maximumNumberOfLines:label.numberOfLines forceUseFixedLineHeight:NO widthToFit:NO];
        label.height = textSize.height;
        
        _labelEmoticon3 = label;
    }
    
    return _labelEmoticon3;
}

- (UILabel *)labelEmoticon4 {
    if (!_labelEmoticon4) {
        NSString *text = @"这是一个微笑表情[微笑]，[比心]还有其他表情[开心][送花花][可爱][睡][色][闭嘴]";
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17],
        };
        
        CGFloat width = 280;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_labelEmoticon3.frame) + 10, width, 0)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 10;
        label.attributedText = [[WCEmoticonDataSource sharedInstance] emoticonizedStringWithString:text attributes:attrs];
        CGSize textSize = [WCAttributedStringTool textSizeWithFixedLineAttributedString:label.attributedText width:width maximumNumberOfLines:label.numberOfLines forceUseFixedLineHeight:NO widthToFit:NO];
        label.height = textSize.height;
        
        _labelEmoticon4 = label;
    }
    
    return _labelEmoticon4;
}

- (UILabel *)labelEmoticon5 {
    if (!_labelEmoticon5) {
        NSString *text = @"这是一个微笑表情[微笑]，[比心]还有其他表情[开心][送花花][可爱][睡][色][闭嘴]";
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17],
        };
        
        CGFloat width = 280;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_labelEmoticon4.frame) + 10, width, 0)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 10;
        label.attributedText = [[WCEmoticonDataSource sharedInstance] emoticonizedStringWithString:text attributes:attrs];
        CGSize textSize = [WCAttributedStringTool textSizeWithFixedLineAttributedString:label.attributedText width:width maximumNumberOfLines:label.numberOfLines forceUseFixedLineHeight:YES widthToFit:NO];
        label.height = textSize.height;
        
        _labelEmoticon5 = label;
    }
    
    return _labelEmoticon5;
}

@end
