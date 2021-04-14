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
    
    /*
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationDidBecomeActiveNotification1:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUIApplicationDidBecomeActiveNotification2:) name:UIApplicationDidBecomeActiveNotification object:nil];
     */
    
    [WCNotificationTool addObserver:self selector:@selector(handleUIApplicationDidBecomeActiveNotification1:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [WCNotificationTool addObserver:self selector:@selector(handleUIApplicationDidBecomeActiveNotification2:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    /*
    [WCNotificationTool addObserver:self name:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notification) {
        NSLog(@"become active");
    }];
    
    [WCNotificationTool addObserver:self name:UIApplicationDidBecomeActiveNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notification) {
        NSLog(@"become active2");
    }];
    
    [WCNotificationTool addObserver:self name:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull notification) {
        NSLog(@"will enter foreground");
    }];
     */
}

#pragma mark - NSNotification

- (void)handleUIApplicationDidBecomeActiveNotification1:(NSNotification *)notification {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

- (void)handleUIApplicationDidBecomeActiveNotification2:(NSNotification *)notification {
    NSLog(@"_cmd: %@", NSStringFromSelector(_cmd));
}

@end
