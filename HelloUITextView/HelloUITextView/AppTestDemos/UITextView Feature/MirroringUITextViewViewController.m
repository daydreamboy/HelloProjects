//
//  MirroringUITextViewViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/6.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "MirroringUITextViewViewController.h"

@interface MirroringUITextViewViewController ()
@property (nonatomic, strong) UITextView *textView1;
@property (nonatomic, strong) UITextView *textView2;
@property (nonatomic, strong) NSTextStorage *textStorage;
@end

@implementation MirroringUITextViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _textStorage = [[NSTextStorage alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit."];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textView1];
    [self.view addSubview:self.textView2];
}

#pragma mark - Getter

- (UITextView *)textView1 {
    if (!_textView1) {
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect rect = CGRectMake(5, startY + 5, (screenSize.width - 20) / 2.0, 300);
        
        NSTextContainer *textContainer = [NSTextContainer new];
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        [layoutManager addTextContainer:textContainer];
        [self.textStorage addLayoutManager:layoutManager];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:rect textContainer:textContainer];
        textView.font = [UIFont systemFontOfSize:17];
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _textView1 = textView;
    }
    
    return _textView1;
}

- (UITextView *)textView2 {
    if (!_textView2) {
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect rect = CGRectMake(CGRectGetMaxX(_textView1.frame) + 10, startY + 5, (screenSize.width - 20) / 2.0, 300);
        
        NSTextContainer *textContainer = [NSTextContainer new];
        NSLayoutManager *layoutManager = [NSLayoutManager new];
        [layoutManager addTextContainer:textContainer];
        [self.textStorage addLayoutManager:layoutManager];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:rect textContainer:textContainer];
        textView.font = [UIFont systemFontOfSize:17];
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        // Note: fix not line wrap when first show
        textView.scrollEnabled = NO;
        
        _textView2 = textView;
    }
    
    return _textView2;
}

@end
