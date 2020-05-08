//
//  UseExceptionHanderViewController.m
//  HelloCrash
//
//  Created by wesley_chen on 23/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseExceptionHanderViewController.h"
#import "WCCrashCaseTool.h"
#import "WCExceptionTool.h"

void UseExceptionHanderViewController_HandleException(NSException *exception)
{
    [WCExceptionTool writeCrashReportWithException:exception enablePrintToConsole:YES crashReportFileName:ExceptionLogFileName];
}

@interface UseExceptionHanderViewController ()
@property (nonatomic, strong) UISwitch *switcher;
@end

@implementation UseExceptionHanderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISwitch *switcher = [[UISwitch alloc] init];
    switcher.on = NO;
    [switcher addTarget:self action:@selector(toggleExceptionHandler:) forControlEvents:UIControlEventValueChanged];
    self.switcher = switcher;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:switcher];
}

#pragma mark - Action

- (void)toggleExceptionHandler:(UISwitch *)sender {
    if (sender.on) {
        [self installUncaughtExceptionHandler];
    }
    else {
        [self uninstallUncaughtExceptionHandler];
    }
}

#pragma mark

- (void)installUncaughtExceptionHandler {
    NSSetUncaughtExceptionHandler(&UseExceptionHanderViewController_HandleException);
}

- (void)uninstallUncaughtExceptionHandler {
    NSSetUncaughtExceptionHandler(NULL);
}

@end
