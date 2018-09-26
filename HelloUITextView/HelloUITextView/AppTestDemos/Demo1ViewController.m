//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"

@interface Demo1ViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarItem1 = [[UIBarButtonItem alloc] initWithTitle:@"Insert" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItem1Clicked:)];
    
    UIBarButtonItem *rightBarItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItem2Clicked:)];
    
    self.navigationItem.rightBarButtonItems = @[rightBarItem1, rightBarItem2];
    
    [self.view addSubview:self.textView];
}

#pragma mark - Getters

- (UITextView *)textView {
    if (!_textView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 60, screenSize.width, screenSize.height - 60)];
        textView.text = @"Some Text";
        
        _textView = textView;
    }
    
    return _textView;
}

#pragma mark - Actions

- (void)rightBarItem1Clicked:(id)sender {
    NSString *insertingString = @"InsertedText";
    [self.textView replaceRange:self.textView.selectedTextRange withText:insertingString];
}

- (void)rightBarItem2Clicked:(id)sender {
    NSLog(@"dismiss");
    [self.textView resignFirstResponder];
//    NSString *insertingString = @"InsertedText";
//    [self.textView replaceRange:self.textView.selectedTextRange withText:insertingString];
}

@end
