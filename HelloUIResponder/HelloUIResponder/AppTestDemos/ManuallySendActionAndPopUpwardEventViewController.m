//
//  ManuallySendActionAndPopUpwardEventViewController.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2021/3/31.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "ManuallySendActionAndPopUpwardEventViewController.h"

@interface ManuallySendActionAndPopUpwardEventViewController ()

@end

@implementation ManuallySendActionAndPopUpwardEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Note: from first responder pop up to the AppDelegate
    // Warning: not call this method in viewDidLoad method, the responder chain has not yet setup
    [[UIApplication sharedApplication] sendAction:@selector(myCustomMethod) to:nil from:self.view forEvent:nil];
}

@end
