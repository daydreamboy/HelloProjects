//
//  UseYYTextViewViewController.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/8/18.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseYYTextViewViewController.h"
#import "YYKit.h"
#import "WCStringTool.h"
#import "WCMacroTool.h"

#define TextMaximumWidth 230.0
#define TextInsets UIEdgeInsetsMake(14, 14, 14, 14)
#define TextFont [UIFont systemFontOfSize:17]

@interface UseYYTextViewViewController ()
@property (nonatomic, strong) YYTextView *textView;
@end

@implementation UseYYTextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = TextFont;
    
    NSString *text = @"测试实施";
    NSAttributedString *attrString = ASTR2(text, attributes);
    CGSize textSize = [WCStringTool textSizeWithMultipleLineString:text width:TextMaximumWidth font:TextFont mode:NSLineBreakByCharWrapping widthToFit:YES];

    CGSize size = CGSizeMake(TextMaximumWidth, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:size text:attrString];
    
    self.textView.attributedText = attrString;
    self.textView.frame = CGRectMake(80, 150, layout.textBoundingSize.width, layout.textBoundingSize.height);
    
    self.textView.textContainerInset = UIEdgeInsetsZero;
    CGSize newSize = [self.textView sizeThatFits:size];
    self.textView.frame = CGRectMake(80, 150, newSize.width, newSize.height);
    
    [self.view addSubview:self.textView];
}

#pragma mark - Getter

- (YYTextView *)textView {
    if (!_textView) {
        YYTextView *textView = [YYTextView new];
        textView.backgroundColor = [UIColor clearColor];
        textView.scrollEnabled = NO;
        textView.editable = NO;
        //textView.textContainerInset = self.item.contentInset;
//        textView.disableSystemMenu = YES;
//        textView.selectAllAtTheBeginning = YES;
        //textView.delegate = self.attachmentDelegate;
//        textView.longPressMinimumDuration = 0.3;
    //        textView.tintColor = [UIColor common_blue1_color];
        _textView = textView;
    }
    
    return _textView;
}

@end
