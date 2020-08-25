//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "PlaceholderViewController.h"
#import "WCPlaceholderTextView.h"

@interface PlaceholderViewController ()
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) WCPlaceholderTextView *textViewPlaceholder;
@end

@implementation PlaceholderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *rightBarItem1 = [[UIBarButtonItem alloc] initWithTitle:@"Insert" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItem1Clicked:)];
    
    UIBarButtonItem *rightBarItem2 = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarItem2Clicked:)];
    
    self.navigationItem.rightBarButtonItems = @[rightBarItem1, rightBarItem2];
    
    //[self.view addSubview:self.textView];
    [self.view addSubview:self.textViewPlaceholder];
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

- (WCPlaceholderTextView *)textViewPlaceholder {
    if (!_textViewPlaceholder) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCPlaceholderTextView *textView = [[WCPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 90 + 10, screenSize.width - 2 * 10, 300)];
        //textView.text = @"Some Text";
        //textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type here..."];
        textView.font = [UIFont systemFontOfSize:17];
        textView.textAlignment = NSTextAlignmentNatural;
        textView.placeholder = @"Test Test Test TestTest TestTest TestTest TestTest TestTest Test23";
        //textView.placeholderColor = [UIColor greenColor];
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
        _textViewPlaceholder = textView;
    }
    
    return _textViewPlaceholder;
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
