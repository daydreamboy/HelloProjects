//
//  HTMLCodeEditUIViewController.m
//  HelloJavaScriptCore
//
//  Created by wesley_chen on 2019/12/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "HTMLCodeEditUIViewController.h"
#import "WCWebViewTool.h"
#import <WebKit/WebKit.h>

// https://github.com/google/code-prettify
// run_prettify.js: https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/run_prettify.js
// prettify.css: https://cdn.jsdelivr.net/gh/google/code-prettify@master/loader/prettify.css
// Example: https://raw.githack.com/google/code-prettify/master/examples/quine.html
@interface HTMLCodeEditUIViewController ()
@property (nonatomic, strong) UITextView *textViewEdit;
@property (nonatomic, strong, readonly) NSArray *leftBarButtonItems;
@property (nonatomic, strong, readonly) NSArray *rightBarButtonItems;
@property (nonatomic, strong) WKWebView *webView;
@end

@implementation HTMLCodeEditUIViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    [self.view addGestureRecognizer:tapGesture];
    
    self.navigationItem.leftBarButtonItems = self.leftBarButtonItems;
    self.navigationItem.rightBarButtonItems = self.rightBarButtonItems;
    
//    [self.view addSubview:self.textViewEdit];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIKeyboardWillShowNotification:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIKeyboardWillHideNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    self.textViewEdit.text = self.HTMLCodeString;
    
    
    NSString *HTMLString = [NSString stringWithFormat:@"<html><body><pre class=\"prettyprint linenums\"><code class=\"language-html\">%@</code></pre></body></html>", self.HTMLCodeString];
    [self.webView loadHTMLString:HTMLString baseURL:nil];
    [self.view addSubview:self.webView];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - NSNotifications

- (void)handleUIKeyboardWillShowNotification:(NSNotification *)notification {
}

- (void)handleUIKeyboardWillHideNotification:(NSNotification *)notification {
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
        textView.font = [UIFont systemFontOfSize:15];
        textView.tintColor = [UIColor cyanColor];
        
        _textViewEdit = textView;
    }
    
    return _textViewEdit;
}

- (WKWebView *)webView {
    if (!_webView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = CGRectGetMaxY(self.navigationController.navigationBar.frame);
        CGRect frame = CGRectMake(0, 0, screenSize.width, screenSize.height - startY);
        
        WKUserContentController *userContentController = [WKUserContentController new];
        
        // https://stackoverflow.com/a/26583062
        NSString *JSCode1 = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);";
        WKUserScript *script1 = [[WKUserScript alloc] initWithSource:JSCode1 injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
        [userContentController addUserScript:script1];
        
        NSError *error;
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"run_prettify" ofType:@"js"];
        NSString *JSCode2 = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];
        WKUserScript *script2 = [[WKUserScript alloc] initWithSource:JSCode2 injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:YES];
        [userContentController addUserScript:script2];
        
        filePath = [[NSBundle mainBundle] pathForResource:@"prettify_modified" ofType:@"css"];
        [userContentController addUserScript:[WCWebViewTool userScriptWithAppendCSSAtFilePath:filePath]];
        
        WKWebViewConfiguration *configuration = [WKWebViewConfiguration new];
        configuration.userContentController = userContentController;
        
        WKWebView *webView = [[WKWebView alloc] initWithFrame:frame configuration:configuration];
        _webView = webView;
    }
    
    return _webView;
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

#pragma mark - Actions

- (void)listItemClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)formatItemClicked:(id)sender {
//    SHOW_ALERT(@"Whoops!", @"Not supported now", @"Ok", nil);
    
    [WCWebViewTool documentStringWithWKWebView:self.webView completion:^(NSString * _Nullable documentString, NSError * _Nullable error) {
        NSLog(@"%@", documentString);
    }];
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
