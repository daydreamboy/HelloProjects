//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UseWCPlaceholderTextViewViewController.h"
#import "WCPlaceholderTextView.h"

@interface UseWCPlaceholderTextViewViewController ()
@property (nonatomic, strong) WCPlaceholderTextView *textView;
@end

@implementation UseWCPlaceholderTextViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *insertItem = [[UIBarButtonItem alloc] initWithTitle:@"Insert" style:UIBarButtonItemStylePlain target:self action:@selector(insertItemClicked:)];
    
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(dismissItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[insertItem, dismissItem];
    
    [self.view addSubview:self.textView];
}

#pragma mark - Getters

- (WCPlaceholderTextView *)textView {
    if (!_textView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCPlaceholderTextView *textView = [[WCPlaceholderTextView alloc] initWithFrame:CGRectMake(10, 90 + 10, screenSize.width - 2 * 10, 300) textContainer:nil];
        //textView.text = @"Some Text";
        //textView.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Type here..."];
        textView.font = [UIFont systemFontOfSize:17];
        textView.textAlignment = NSTextAlignmentNatural;
        textView.placeholder = @"Test Test Test TestTest TestTest TestTest TestTest TestTest Test23";
        //textView.placeholderColor = [UIColor greenColor];
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        
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
