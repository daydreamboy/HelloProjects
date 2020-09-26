//
//  UseWCMessageComposerViewViewController.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseWCMessageComposerViewViewController.h"
#import "WCMessageComposerView.h"
#import "WCKeyboardObserver.h"

@interface UseWCMessageComposerViewViewController ()
@property (nonatomic, strong) WCMessageComposerView *messageComposerView;
@property (nonatomic, strong) WCKeyboardObserver *keyboardObserver;
@property (nonatomic, assign) BOOL isVisibleKeyboard;
@end

@implementation UseWCMessageComposerViewViewController

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
    
    [self.view addSubview:self.messageComposerView];
    
    [self.messageComposerView setupBottomAutoLayoutWithViewController:self keyboardWillAnimate:^(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isToShow) {
            
        } keyboardInAnimate:^(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isToShow) {
            
        } keyboardDidAnimate:^(BOOL finished, BOOL isToShow) {
            
        }];
    
//    [self.keyboardObserver registerObserverWithKeyboardWillAnimate:nil inAnimate:^(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isToShow) {
//        self.isVisibleKeyboard = isToShow;
//        [self adjustContentWithKeyboardRect:keyboardRectEnd];
//    } didAnimate:^(BOOL finished, BOOL isToShow) {
//        self.isVisibleKeyboard = isToShow;
//    }];
    
    //[self setupConstraint];
}

//- (void)adjustContentWithKeyboardRect:(CGRect)rect {
//    CGFloat keyboardHeight = CGRectGetHeight(rect);
//
//    self.constraintSpaceBetweenBottomLayoutGuide.constant = self.isVisibleKeyboard ? keyboardHeight - self.bottomLayoutGuide.length : 0.0;
//    [self.view layoutIfNeeded];
//}

#pragma mark - Getter

- (WCMessageComposerView *)messageComposerView {
    if (!_messageComposerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCMessageComposerView *view = [[WCMessageComposerView alloc] initWithFrame:CGRectMake(0, 100, screenSize.width, 0)];
        view.backgroundColor = [UIColor greenColor];
        view.textInputAreaInsets = UIEdgeInsetsZero;
        view.textFont = [UIFont systemFontOfSize:28];
        _messageComposerView = view;
    }
    
    return _messageComposerView;
}

@end
