//
//  UseWCGrowingTextViewViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/8/31.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseWCGrowingTextViewViewController.h"
#import "WCGrowingTextView.h"

@interface UseWCGrowingTextViewViewController ()
@property (nonatomic, strong) WCGrowingTextView *textView;
@end

@implementation UseWCGrowingTextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *insertItem = [[UIBarButtonItem alloc] initWithTitle:@"Insert" style:UIBarButtonItemStylePlain target:self action:@selector(insertItemClicked:)];
    
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(dismissItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[insertItem, dismissItem];
    
    [self.view addSubview:self.textView];
}

#pragma mark - Getters

- (WCGrowingTextView *)textView {
    if (!_textView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCGrowingTextView *textView = [[WCGrowingTextView alloc] initWithFrame:CGRectMake(10, 90 + 10, screenSize.width - 2 * 10, 300) textContainer:nil];
        textView.enableHeightChangeAnimation = NO;
        textView.contentInset = UIEdgeInsetsMake(20, 10, 20, 10);
        textView.font = [UIFont systemFontOfSize:17];
        textView.textAlignment = NSTextAlignmentNatural;
        textView.maximumNumberOfLines = 3;
        textView.placeholder = @"Write a message";
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textView.text = @"我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。";
        
        _textView = textView;
    }
    
    return _textView;
}


#pragma mark - Actions

- (void)insertItemClicked:(id)sender {
    NSString *insertingString = @"InsertedText";
    [self.textView replaceRange:self.textView.selectedTextRange withText:insertingString];
}

- (void)dismissItemClicked:(id)sender {
    [self.textView resignFirstResponder];
}

@end
