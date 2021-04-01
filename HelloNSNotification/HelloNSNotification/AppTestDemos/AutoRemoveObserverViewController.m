//
//  AutoRemoveObserverViewController.m
//  HelloNSNotification
//
//  Created by wesley_chen on 2021/4/1.
//

#import "AutoRemoveObserverViewController.h"
#import "WCNotificationTool.h"

@interface AutoRemoveObserverViewController ()

@end

@implementation AutoRemoveObserverViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [WCNotificationTool addObserver:self name:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notification) {
        NSLog(@"become active");
    }];
}

@end
