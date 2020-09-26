//
//  SyntaxHighlightUITextViewViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/6.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "SyntaxHighlightUITextViewViewController.h"
#import "WCHighlightTextStorage.h"

@interface SyntaxHighlightUITextViewViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) WCHighlightTextStorage *textStorage;
@end

@implementation SyntaxHighlightUITextViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        
        // Regular expression matching all iWords -- first character i, followed by an uppercase alphabetic character, followed by at least one other character. Matches words like iPod, iPhone, etc.
        // Note:
        // - p{unicode property}
        // &&, indicates the intersecton. @see https://www.mpi.nl/corpus/html/elan/apa.html
        NSString *pattern = @"i[\\p{Alphabetic}&&\\p{Uppercase}][\\p{Alphabetic}]+";
        
        _textStorage = [[WCHighlightTextStorage alloc] initWithPattern:pattern highlightAttributes:@{
            NSForegroundColorAttributeName: [UIColor redColor],
        }];
        
        // Load iText
        [_textStorage replaceCharactersInRange:NSMakeRange(0, 0) withString:[NSString stringWithContentsOfURL:[NSBundle.mainBundle URLForResource:@"iText" withExtension:@"txt"] usedEncoding:NULL error:NULL]];
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
        
        [layoutManager addTextContainer:textContainer];
        [self.textStorage addLayoutManager:layoutManager];
        
        UITextView *textView = [[UITextView alloc] initWithFrame:rect textContainer:textContainer];
        textView.font = [UIFont systemFontOfSize:17];
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _textView = textView;
    }
    
    return _textView;
}

@end
