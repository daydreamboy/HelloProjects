//
//  GetSymbolicCallStackViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2020/5/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetSymbolicCallStackViewController.h"
#import <mach-o/dyld.h>
#import "WCThreadTool.h"

@interface GetSymbolicCallStackViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation GetSymbolicCallStackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *viewCallStackItem = [[UIBarButtonItem alloc] initWithTitle:@"View CallStack" style:UIBarButtonItemStylePlain target:self action:@selector(viewCallStackItem:)];
    
    self.navigationItem.rightBarButtonItems = @[viewCallStackItem];
    
    [self.view addSubview:self.textView];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.textView.frame = self.view.bounds;
}

#pragma mark - Getter

- (UITextView *)textView {
    if (!_textView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, screenSize.height)];
        
        _textView = textView;
    }
    
    return _textView;
}

#pragma mark - Action

- (void)viewCallStackItem:(id)sender {
    self.textView.text = [WCThreadTool currentThreadCallStackString];
}

@end
