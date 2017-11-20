//
//  BaseViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 30/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationWillTerminateNotification:) name:UIApplicationWillTerminateNotification object:nil];
}

#pragma mark - Notifications

- (void)handleUIApplicationDidEnterBackgroundNotification:(NSNotification *)notification {
    [self.coreDataStack saveContext];
}

- (void)handleUIApplicationWillTerminateNotification:(NSNotification *)notification {
    [self.coreDataStack saveContext];
}

@end
