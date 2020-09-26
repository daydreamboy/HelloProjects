//
//  TextViewIssueCaretViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "TextViewIssueCaretViewController.h"

@interface TextViewIssueCaretViewController ()
@property (nonatomic, strong) UITextView *textViewPositional;
@end

@implementation TextViewIssueCaretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textViewPositional];
}

- (UITextView *)textViewPositional {
    if (!_textViewPositional) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 90 + 10, screenSize.width - 2 * 10, 30) textContainer:nil];
        textView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        // Note: disable left/right padding on each line
        textView.textContainer.lineFragmentPadding = 0;
        textView.textContainerInset = UIEdgeInsetsZero;
        textView.textContainer.widthTracksTextView = NO;
        textView.textContainer.heightTracksTextView = NO;
        //textView.enableHeightChangeAnimation = NO;
//        textView.contentInset = UIEdgeInsetsMake(20, 10, 20, 10);
//        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        textView.font = [UIFont systemFontOfSize:17];
        //textView.textAlignment = NSTextAlignmentNatural;
        //textView.maximumNumberOfLines = 3;
        //textView.placeholder = @"Write a message";
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textView.text = @"我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。";
        textView.text = @"";
        textView.backgroundColor = [UIColor yellowColor];
        
        textView.frame = CGRectMake(10, 90 + 40, 300, 30);
        [textView.layoutManager ensureLayoutForTextContainer:textView.textContainer];
        textView.textContainer.size = CGSizeMake(300, 0);
        
        
        _textViewPositional = textView;
    }
    
    return _textViewPositional;
}

@end
