//
//  MixMirroringAndPagingUITextViewViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/6.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "MixMirroringAndPagingUITextViewViewController.h"

@interface MixMirroringAndPagingUITextViewViewController ()
@property (nonatomic, strong) UITextView *textView1;
@property (nonatomic, strong) UITextView *textView2;
@property (nonatomic, strong) UITextView *textView3;

@property (nonatomic, strong) NSLayoutManager *layoutManager1;
@property (nonatomic, strong) NSLayoutManager *layoutManager2;

@property (nonatomic, strong) NSTextStorage *textStorage;
@end

@implementation MixMirroringAndPagingUITextViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _textStorage = [[NSTextStorage alloc] initWithString:@"Lorem ipsum dolor sit amet, consectetur adipiscing elit. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus magna dolor, volutpat a ipsum et, porttitor molestie justo. Vestibulum sed augue malesuada, congue magna sed, fringilla ligula. Sed aliquet porta vestibulum. Phasellus gravida elit ut ligula vulputate fringilla. Pellentesque sit amet dolor pulvinar, dictum eros non, suscipit purus. Aenean metus mi, sodales ut augue in, varius sagittis mi. "];
        
        _layoutManager1 = [NSLayoutManager new];
        _layoutManager2 = [NSLayoutManager new];
        
        [_textStorage addLayoutManager:_layoutManager1];
        [_textStorage addLayoutManager:_layoutManager2];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textView1];
    [self.view addSubview:self.textView2];
    [self.view addSubview:self.textView3];
}

#pragma mark - Getter

- (UITextView *)textView1 {
    if (!_textView1) {
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect rect = CGRectMake(5, startY + 5, screenSize.width - 10, 100);
        
        NSTextContainer *textContainer = [NSTextContainer new];
        [self.layoutManager1 addTextContainer:textContainer];
        
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
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect rect = CGRectMake(5, CGRectGetMaxY(_textView1.frame) + 5, (screenSize.width - 20) / 2.0, 300);
        
        NSTextContainer *textContainer = [NSTextContainer new];
        [self.layoutManager2 addTextContainer:textContainer];
        
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

- (UITextView *)textView3 {
    if (!_textView3) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGRect rect = CGRectMake(CGRectGetMaxX(_textView2.frame) + 10, CGRectGetMaxY(_textView1.frame) + 5, (screenSize.width - 20) / 2.0, 300);
        
        NSTextContainer *textContainer = [NSTextContainer new];
        [self.layoutManager2 addTextContainer:textContainer];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:rect textContainer:textContainer];
        textView.font = [UIFont systemFontOfSize:17];
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        // Note: fix not line wrap when first show
        textView.scrollEnabled = NO;
        
        _textView3 = textView;
    }
    
    return _textView3;
}

@end
