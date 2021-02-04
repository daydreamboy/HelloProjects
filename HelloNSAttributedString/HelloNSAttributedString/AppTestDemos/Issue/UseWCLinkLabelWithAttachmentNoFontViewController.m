//
//  UseWCLinkLabelWithAttachmentNoFontViewController.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2021/2/4.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "UseWCLinkLabelWithAttachmentNoFontViewController.h"
#import "WCEmoticonDataSource.h"
#import "WCAttributedStringTool.h"
#import "UIView+Addition.h"
#import "WCLinkLabel.h"

@interface UseWCLinkLabelWithAttachmentNoFontViewController ()
@property (nonatomic, strong) WCLinkLabel *labelEmoticon1;
@property (nonatomic, strong) WCLinkLabel *labelEmoticon2;
@property (nonatomic, strong) WCLinkLabel *labelEmoticon1_fixed;
@property (nonatomic, strong) WCLinkLabel *labelEmoticon2_fixed;
@end

@implementation UseWCLinkLabelWithAttachmentNoFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.labelEmoticon1];
    [self.view addSubview:self.labelEmoticon2];
    [self.view addSubview:self.labelEmoticon1_fixed];
    [self.view addSubview:self.labelEmoticon2_fixed];
}

#pragma mark - Getter

- (WCLinkLabel *)labelEmoticon1 {
    if (!_labelEmoticon1) {
        NSString *text = @"分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？[抱拳]你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样";
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17],
        };
        
        CGFloat width = 338;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        WCLinkLabel *label = [[WCLinkLabel alloc] initWithFrame:CGRectMake(10, startY + 10, width, 0)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 0;
        label.attributedText = [[WCEmoticonDataSource sharedInstance] issue_emoticonizedStringWithString:text attributes:attrs];
        CGSize textSize = [WCAttributedStringTool textSizeWithFixedLineAttributedString:label.attributedText width:width maximumNumberOfLines:label.numberOfLines forceUseFixedLineHeight:NO widthToFit:NO];
        label.height = textSize.height;
        
        _labelEmoticon1 = label;
    }
    
    return _labelEmoticon1;
}

- (WCLinkLabel *)labelEmoticon2 {
    if (!_labelEmoticon2) {
        NSString *text = @"分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样[抱拳]";
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17],
        };
        
        CGFloat width = 338;
        WCLinkLabel *label = [[WCLinkLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_labelEmoticon1.frame) + 10, width, 0)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 0;
        label.attributedText = [[WCEmoticonDataSource sharedInstance] issue_emoticonizedStringWithString:text attributes:attrs];
        CGSize textSize = [WCAttributedStringTool textSizeWithFixedLineAttributedString:label.attributedText width:width maximumNumberOfLines:label.numberOfLines forceUseFixedLineHeight:NO widthToFit:NO];
        label.height = textSize.height;
        
        _labelEmoticon2 = label;
    }
    
    return _labelEmoticon2;
}

- (WCLinkLabel *)labelEmoticon1_fixed {
    if (!_labelEmoticon1_fixed) {
        NSString *text = @"分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样[抱拳]";
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17],
        };
        
        CGFloat width = 338;
        WCLinkLabel *label = [[WCLinkLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_labelEmoticon2.frame) + 10, width, 0)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 0;
        label.attributedText = [[WCEmoticonDataSource sharedInstance] emoticonizedStringWithString:text attributes:attrs];
        CGSize textSize = [WCAttributedStringTool textSizeWithFixedLineAttributedString:label.attributedText width:width maximumNumberOfLines:label.numberOfLines forceUseFixedLineHeight:NO widthToFit:NO];
        label.height = textSize.height;
        
        _labelEmoticon1_fixed = label;
    }
    
    return _labelEmoticon1_fixed;
}

- (WCLinkLabel *)labelEmoticon2_fixed {
    if (!_labelEmoticon2_fixed) {
        NSString *text = @"分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样分隔符管不了的是什么的最爱了？你是什么你热的时候就像一条条一样[抱拳]";
        NSDictionary *attrs = @{
            NSFontAttributeName: [UIFont systemFontOfSize:17],
        };
        
        CGFloat width = 338;
        WCLinkLabel *label = [[WCLinkLabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_labelEmoticon1_fixed.frame) + 10, width, 0)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.numberOfLines = 0;
        label.attributedText = [[WCEmoticonDataSource sharedInstance] emoticonizedStringWithString:text attributes:attrs];
        CGSize textSize = [WCAttributedStringTool textSizeWithFixedLineAttributedString:label.attributedText width:width maximumNumberOfLines:label.numberOfLines forceUseFixedLineHeight:NO widthToFit:NO];
        label.height = textSize.height;
        
        _labelEmoticon2_fixed = label;
    }
    
    return _labelEmoticon2_fixed;
}


@end
