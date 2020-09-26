//
//  UseWCGrowingTextViewViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/8/31.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseWCGrowingTextViewViewController.h"
#import "WCGrowingTextView.h"
#import "WCKeyboardObserver.h"
#import "WCMacroTool.h"

@interface UseWCGrowingTextViewViewController ()
@property (nonatomic, strong) WCGrowingTextView *textViewPositional;
@property (nonatomic, strong) WCGrowingTextView *textViewFollowing;
@property (nonatomic, strong) WCKeyboardObserver *keyboardObserver;
@property (nonatomic, assign) BOOL isVisibleKeyboard;
@property (nonatomic, strong) NSLayoutConstraint *constraintSpaceBetweenBottomLayoutGuide;
@end

@implementation UseWCGrowingTextViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _keyboardObserver = [[WCKeyboardObserver alloc] initWithObservee:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *insertItem = [[UIBarButtonItem alloc] initWithTitle:@"Insert" style:UIBarButtonItemStylePlain target:self action:@selector(insertItemClicked:)];
    
    UIBarButtonItem *dismissItem = [[UIBarButtonItem alloc] initWithTitle:@"Dismiss" style:UIBarButtonItemStylePlain target:self action:@selector(dismissItemClicked:)];
    
    self.navigationItem.rightBarButtonItems = @[insertItem, dismissItem];
    
    [self.view addSubview:self.textViewPositional];
    [self.view addSubview:self.textViewFollowing];
    
    [self.keyboardObserver registerObserverWithKeyboardWillAnimate:nil inAnimate:^(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isToShow) {
        self.isVisibleKeyboard = isToShow;
        [self adjustContentWithKeyboardRect:keyboardRectEnd];
    } didAnimate:^(BOOL finished, BOOL isToShow) {
        self.isVisibleKeyboard = isToShow;
    }];
    
    [self setupConstraint];
}

- (void)setupConstraint {
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.bottomLayoutGuide attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.textViewFollowing attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    self.constraintSpaceBetweenBottomLayoutGuide = constraint;
    
    [self.view addConstraint:constraint];
    
    [self.view addConstraint:({
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.textViewFollowing attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeLeading multiplier:1 constant:10];
        constraint;
    })];
    
    [self.view addConstraint:({
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.textViewFollowing attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-10];
        constraint;
    })];
    
    // Note: Don't set height constraint, let text view auto adjust height
    /*
    [self.view addConstraint:({
        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self.textViewFollowing attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeHeight multiplier:1 constant:30];
        constraint;
    })];
     */
}

- (void)adjustContentWithKeyboardRect:(CGRect)rect {
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    
    self.constraintSpaceBetweenBottomLayoutGuide.constant = self.isVisibleKeyboard ? keyboardHeight - self.bottomLayoutGuide.length : 0.0;
    [self.view layoutIfNeeded];
}

#pragma mark - Getters

- (WCGrowingTextView *)textViewPositional {
    if (!_textViewPositional) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCGrowingTextView *textView = [[WCGrowingTextView alloc] initWithFrame:CGRectMake(10, 90 + 10, 300, UNSPECIFIED) textContainer:nil];
        //textView.enableHeightChangeAnimation = NO;
//        textView.contentInset = UIEdgeInsetsMake(20, 10, 20, 10);
//        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
//        textView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
        textView.font = [UIFont systemFontOfSize:17];
        //textView.textAlignment = NSTextAlignmentNatural;
        textView.maximumNumberOfLines = 3;
        textView.placeholder = @"Write a message";
        //textView.layer.borderColor = [UIColor redColor].CGColor;
        //textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textView.text = @"我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。我的生活方式就是这样吧🤭。";
        textView.text = @"";
        textView.backgroundColor = [UIColor yellowColor];
        
        textView.frame = CGRectMake(10, 90 + 40, 400, 0);
        textView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
//        textView.textContainer.size = CGSizeMake(400, 0);
//        textView.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
//        // Note: disable left/right padding on each line
//        textView.textContainer.lineFragmentPadding = 0;
//        textView.textContainerInset = UIEdgeInsetsZero;
        
        _textViewPositional = textView;
    }
    
    return _textViewPositional;
}

- (WCGrowingTextView *)textViewFollowing {
    if (!_textViewFollowing) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        WCGrowingTextView *textView = [[WCGrowingTextView alloc] initWithFrame:CGRectMake(10, 0, screenSize.width - 2 * 10, UNSPECIFIED) textContainer:nil];
        textView.enableHeightChangeAnimation = NO;
        textView.contentInset = UIEdgeInsetsMake(20, 10, 20, 10);
        textView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        textView.font = [UIFont systemFontOfSize:17];
        textView.textAlignment = NSTextAlignmentNatural;
        textView.maximumNumberOfLines = 3;
        textView.placeholder = @"Write a message";
        textView.layer.borderColor = [UIColor redColor].CGColor;
        textView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        textView.text = @"";
        textView.translatesAutoresizingMaskIntoConstraints = NO;
        textView.backgroundColor = [UIColor yellowColor];
        
        _textViewFollowing = textView;
    }
    
    return _textViewFollowing;
}


#pragma mark - Actions

- (void)insertItemClicked:(id)sender {
    //NSString *insertingString = @"InsertedText";
    //[self.textViewPositional replaceRange:self.textViewPositional.selectedTextRange withText:insertingString];
    
//    self.textViewPositional.frame = FrameSetSize(self.textViewPositional.frame, 200, NAN);
//    self.textViewPositional.contentInset = self.textViewPositional.contentInset;
//    [self.textViewPositional layoutIfNeeded];
}

- (void)dismissItemClicked:(id)sender {
    [self.textViewPositional resignFirstResponder];
    [self.textViewFollowing resignFirstResponder];
}

@end
