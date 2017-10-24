//
//  ViewController.m
//  HelloUITextField
//
//  Created by wesley chen on 15/5/8.
//  Copyright (c) 2015年 wesley chen. All rights reserved.
//

#import "Demo1ViewController.h"

@interface Demo1ViewController () <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *textField;

@end

@implementation NSString (Addtion)

/**
 *  Get a url-encoding string
 *
 *  @param encoding NSUTF8StringEncoding
 *
 *  @sa http://stackoverflow.com/questions/8088473/how-do-i-url-encode-a-string
 *  @sa AFPercentEscapedQueryStringPairMemberFromStringWithEncoding method in AFHTTPClient.m
 *  @note https://en.wikipedia.org/wiki/Percent-encoding
 *
 *  @return the url-encoding string
 */
- (NSString *)urlEncodedStringWithEncoding:(NSStringEncoding)encoding {
    static NSString *const kAFCharactersToBeEscaped = @":/?&=;+!@#$()',*";
    static NSString *const kAFCharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)self, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
    
    return encodedString;
}

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textField];
//    [self.textField becomeFirstResponder];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - Getters

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(20, 64 + 10, screenSize.width - 2 * 20, 30)];
        textField.delegate = self;
        textField.autocorrectionType = UITextAutocapitalizationTypeNone;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        textField.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textField.layer.cornerRadius = 3.0f;
        textField.placeholder = @"Type here...";
        
        [textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
        [textField addTarget:self action:@selector(textFieldDidEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
        
        _textField = textField;
    }
    
    return _textField;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldEditingChanged:(UITextField *)sender {
    NSLog(@"%@", sender.text);
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"%@", textField.text);
    NSLog(@"test");
}

- (void)textFieldTextDidChange:(NSNotification *)notification {
    UITextField *textField = notification.object;
    NSLog(@"%@", textField.text);
    
    NSLog(@"%@", [textField.text urlEncodedStringWithEncoding:NSUTF8StringEncoding]);
    
    NSString *str = [@" " stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", str);
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSLog(@"range: %@", NSStringFromRange([self selectedRange:textField]));
    
    NSLog(@"range: %@, string: %@", NSStringFromRange(range), string);
    return YES;
}

// http://stackoverflow.com/questions/21149767/convert-selectedtextrange-uitextrange-to-nsrange
- (NSRange)selectedRange:(id<UITextInput>)textField {
	UITextPosition *beginning = textField.beginningOfDocument;

	UITextRange *selectedRange = textField.selectedTextRange;
	UITextPosition *selectionStart = selectedRange.start;
	UITextPosition *selectionEnd = selectedRange.end;

	const NSInteger location = [textField offsetFromPosition:beginning toPosition:selectionStart];
	const NSInteger length = [textField offsetFromPosition:selectionStart toPosition:selectionEnd];

	return NSMakeRange(location, length);
}

@end
