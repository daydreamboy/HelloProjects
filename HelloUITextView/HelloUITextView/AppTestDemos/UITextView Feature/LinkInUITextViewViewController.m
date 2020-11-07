//
//  LinkInUITextViewViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/11/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "LinkInUITextViewViewController.h"
#import "WCStringTool.h"
#import "WCMacroTool.h"

@interface LinkInUITextViewViewController () <UITextViewDelegate>
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSTextStorage *textStorage;
@end

@implementation LinkInUITextViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _textStorage = ({
            NSString *string = @"This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... This is a link https://www.baidu.com, blah, blah, blah, blah... ";
            
            NSString *linkString = @"https://www.baidu.com";
            NSArray<NSValue *> *ranges = [WCStringTool rangesOfSubstringWithString:string substring:linkString];
            
            NSTextStorage *attrStringM = [[NSTextStorage alloc] initWithString:string attributes:@{
                NSFontAttributeName: [UIFont systemFontOfSize:17],
            }];
            
            for (NSValue *value in ranges) {
                NSRange linkRange = [value rangeValue];
                [attrStringM addAttributes:@{
                    NSForegroundColorAttributeName: [UIColor redColor],
                    NSLinkAttributeName: linkString,
                    
//                    NSForegroundColorAttributeName: [UIColor redColor],
//                    NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
//                    NSUnderlineColorAttributeName: [UIColor colorWithRed:51 / 255.0 green:154 / 255.0 blue:1.0 alpha:1.0],
                } range:linkRange];
            }
            
            attrStringM;
        });

        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textView];
}

#pragma mark - Getter

- (UITextView *)textView {
    if (!_textView) {
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect rect = CGRectMake(5, startY + 5, screenSize.width - 10, 300);
        
        NSTextContainer *textContainer = [NSTextContainer new];
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        textContainer.size = CGSizeMake(rect.size.width, CGFLOAT_MAX);
        
        [layoutManager addTextContainer:textContainer];
        [self.textStorage addLayoutManager:layoutManager];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:rect textContainer:textContainer];
        textView.font = [UIFont systemFontOfSize:17];
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        // Note: set editable to NO, must configure textContainer.size = CGSizeMake(rect.size.width, CGFLOAT_MAX);
        textView.editable = NO;
        textView.delegate = self;
        
        _textView = textView;
    }
    
    return _textView;
}

#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction {
    
    SHOW_ALERT(@"Link Tapped", URL.absoluteString, @"OK", nil);
    
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    
    SHOW_ALERT(@"Link Tapped", URL.absoluteString, @"OK", nil);
    
    return NO;
}

@end
