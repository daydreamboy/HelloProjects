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
@end

@implementation UseWCMessageComposerViewViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        //_keyboardObserver = [[WCKeyboardObserver alloc] initWithObservee:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Getter

- (WCMessageComposerView *)messageComposerView {
    if (!_messageComposerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCMessageComposerView *view = [[WCMessageComposerView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 52)];
        _messageComposerView = view;
    }
    
    return _messageComposerView;
}

@end
