//
//  JSCodeEditViewController.m
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "JSCodeEditViewController.h"
#import "WCMacroKit.h"

@interface JSCodeEditViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UITextView *textViewEdit;
@property (nonatomic, strong, readonly) NSArray *leftBarButtonItems;
@property (nonatomic, strong, readonly) NSArray *rightBarButtonItems;
@end

@implementation JSCodeEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.navigationItem.leftBarButtonItems = self.leftBarButtonItems;
    self.navigationItem.rightBarButtonItems = self.rightBarButtonItems;
    
    [self.scrollView addSubview:self.textViewEdit];
    [self.view addSubview:self.scrollView];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    self.scrollView.contentSize = CGSizeMake(screenSize.width, CGRectGetMaxY(self.textViewEdit.frame) + 10);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    self.textViewEdit.text = self.JSCodeString;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - NSNotifications

- (void)handleUIKeyboardWillShowNotification:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardFrame = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, CGRectGetHeight(keyboardFrame), 0);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, CGRectGetHeight(keyboardFrame), 0);
}

- (void)handleUIKeyboardWillHideNotification:(NSNotification *)notification {
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(64, 0, 0, 0);
}

#pragma mark - Getters

- (UITextView *)textViewEdit {
    if (!_textViewEdit) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat padding = 10;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(padding, padding, screenSize.width - 2 * padding, 400)];
        textView.keyboardType = UIKeyboardTypeASCIICapable;
        textView.autocorrectionType = UITextAutocorrectionTypeNo;
        textView.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textView.layer.borderColor = [UIColor grayColor].CGColor;
        textView.layer.borderWidth = 1;
        textView.layer.cornerRadius = 1;
        textView.backgroundColor = [UIColor blackColor];
        textView.textColor = [UIColor whiteColor];
        
        _textViewEdit = textView;
    }
    
    return _textViewEdit;
}

- (NSArray *)leftBarButtonItems {
    UIBarButtonItem *listItem = [[UIBarButtonItem alloc] initWithTitle:@"<列表" style:UIBarButtonItemStylePlain target:self action:@selector(listItemClicked:)];
    
    return @[listItem];
}

- (NSArray *)rightBarButtonItems {
    UIBarButtonItem *formatItem = [[UIBarButtonItem alloc] initWithTitle:@"格式化" style:UIBarButtonItemStylePlain target:self action:@selector(formatItemClicked:)];
    
    UIBarButtonItem *clearItem = [[UIBarButtonItem alloc] initWithTitle:@"清空" style:UIBarButtonItemStylePlain target:self action:@selector(clearItemClicked:)];
    UIBarButtonItem *pasteItem = [[UIBarButtonItem alloc] initWithTitle:@"粘贴" style:UIBarButtonItemStylePlain target:self action:@selector(pasteItemClicked:)];
    
    UIBarButtonItem *runItem = [[UIBarButtonItem alloc] initWithTitle:@"运行" style:UIBarButtonItemStyleDone target:self action:@selector(runItemClicked:)];
    
    return @[runItem, pasteItem, clearItem, formatItem];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height)];
#ifdef __IPHONE_11_0
#define IOS11_OR_LATER  ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
        if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
#pragma GCC diagnostic pop
        }
#undef IOS11_OR_LATER
#endif
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

#pragma mark - Actions

- (void)formatItemClicked:(id)sender {
    SHOW_ALERT(@"Whoops!", @"Not supported now", @"Ok", nil);
}

- (void)listItemClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)clearItemClicked:(id)sender {
    self.textViewEdit.text = @"";
}

- (void)pasteItemClicked:(id)sender {
    self.textViewEdit.text = [UIPasteboard generalPasteboard].string;
}

- (void)runItemClicked:(id)sender {
    if (self.runBlock) {
        self.runBlock(self.textViewEdit.text);
    }
}

- (void)viewTapped:(id)sender {
    [self.textViewEdit endEditing:YES];
}
@end
