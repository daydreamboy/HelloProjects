//
//  TextViewIssueCaretViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "TextViewIssueCaretViewController.h"

@interface TextViewIssueCaretViewController ()
@property (nonatomic, strong) UITextView *textViewNormal;
@property (nonatomic, strong) UITextView *textViewIssue;
@end

@implementation TextViewIssueCaretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textViewNormal];
    [self.view addSubview:self.textViewIssue];
}

#pragma mark - Getter

- (UITextView *)textViewNormal {
    if (!_textViewNormal) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 90, screenSize.width - 2 * 10, 30) textContainer:nil];
        textView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        // Note: disable left/right padding on each line
        textView.textContainer.lineFragmentPadding = 0;
        textView.textContainerInset = UIEdgeInsetsZero;
        
        textView.font = [UIFont systemFontOfSize:17];
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textView.backgroundColor = [UIColor yellowColor];
        
        _textViewNormal = textView;
    }
    
    return _textViewNormal;
}

- (UITextView *)textViewIssue {
    if (!_textViewIssue) {
        CGFloat startY = 150;
        
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, startY, screenSize.width - 2 * 10, 30) textContainer:nil];
        textView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        
        // Note: disable left/right padding on each line
        textView.textContainer.lineFragmentPadding = 0;
        textView.textContainerInset = UIEdgeInsetsZero;
        
        textView.font = [UIFont systemFontOfSize:17];
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textView.backgroundColor = [UIColor yellowColor];
        
        // !!!: Re-adjust frame will make caret position not correct
        textView.frame = CGRectMake(10, startY, 300, 30);
        
        _textViewIssue = textView;
    }
    
    return _textViewIssue;
}

@end
