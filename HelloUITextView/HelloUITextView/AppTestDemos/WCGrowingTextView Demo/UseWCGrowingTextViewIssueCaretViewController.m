//
//  UseWCGrowingTextViewIssueCaretViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/26.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseWCGrowingTextViewIssueCaretViewController.h"
#import "WCGrowingTextView.h"
#import "WCMacroTool.h"

@interface UseWCGrowingTextViewIssueCaretViewController ()
@property (nonatomic, strong) WCGrowingTextView *textViewIssue;
@end

@implementation UseWCGrowingTextViewIssueCaretViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textViewIssue];
}

#pragma mark - Getter

- (WCGrowingTextView *)textViewIssue {
    if (!_textViewIssue) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCGrowingTextView *textView = [[WCGrowingTextView alloc] initWithFrame:CGRectMake(10, 130, screenSize.width - 2 * 10, UNSPECIFIED) textContainer:nil];
        textView.font = [UIFont systemFontOfSize:17];
        textView.maximumNumberOfLines = 3;
        textView.placeholder = @"Write a message";
        textView.backgroundColor = [UIColor yellowColor];
        
        // !!!: re-adjust frame to make caret position not correct
        textView.frame = CGRectMake(10, 130, 400, UNSPECIFIED);

        _textViewIssue = textView;
    }
    
    return _textViewIssue;
}

@end
