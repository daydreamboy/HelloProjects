//
//  UseWCMulticastDelegateViewController.m
//  HelloNSObject
//
//  Created by wesley_chen on 2020/9/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseWCMulticastDelegateViewController.h"
#import "WCMulticastDelegate.h"

#define SomeTextView MyTextView//UITextView

@interface MyTextView : UITextView <UITextViewDelegate>

@property (nonatomic, strong, readonly) WCMulticastDelegate *multicastDelegate;
@property (nonatomic, weak) id userDelegte;
@end

@interface MyTextView ()
@property (nonatomic, strong, readwrite) WCMulticastDelegate *multicastDelegate;
@end

@implementation MyTextView

#pragma mark - Handle Delegate

// Note: don't override the delegate getter, use userDelegate for outter
//- (id<UITextViewDelegate>)delegate {
//    //return (id<UITextViewDelegate>)self.multicastDelegate;
//    return self;
//}

- (void)setDelegate:(id<UITextViewDelegate>)delegate {
    _userDelegte = delegate;
    if (delegate) {
        [super setDelegate:(id<UITextViewDelegate>)self.multicastDelegate];
    }
    else {
        [super setDelegate:nil];
    }
    
    //[super setDelegate:(id<UITextViewDelegate>)self.multicastDelegate];
}

#pragma mark - Getter

- (WCMulticastDelegate *)multicastDelegate {
    if (!_multicastDelegate) {
        _multicastDelegate = [[WCMulticastDelegate alloc] initWithMiddleMan:self interceptedProtocols:@protocol(UITextViewDelegate), nil];
    }
    
    return _multicastDelegate;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"text: %@", textView.text);
}

//- (void)textViewDidBeginEditing:(UITextView *)textView {
//    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
//}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
    return YES;
}

@end

@interface UseWCMulticastDelegateViewController () <UITextViewDelegate>
@property (nonatomic, strong) SomeTextView *textView;
@end

@implementation UseWCMulticastDelegateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.textView];
}

- (SomeTextView *)textView {
    if (!_textView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        SomeTextView *textView = [[SomeTextView alloc] initWithFrame:CGRectMake(10, 70 + 10, screenSize.width - 2 * 10, 300) textContainer:nil];
        textView.font = [UIFont systemFontOfSize:17];
        textView.textAlignment = NSTextAlignmentNatural;
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textView.text = @"我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。";
        textView.text = @"";
        
        // Note: not works setDelegate
        textView.delegate = self;
        [textView.multicastDelegate addDelegate:self];
        
        _textView = textView;
    }
    
    return _textView;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

//- (void)textViewDidChange:(UITextView *)textView {
//    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
//}

@end
