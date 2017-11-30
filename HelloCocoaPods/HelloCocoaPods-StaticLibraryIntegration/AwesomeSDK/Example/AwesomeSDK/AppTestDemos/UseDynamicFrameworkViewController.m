//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UseDynamicFrameworkViewController.h"
#import <AwesomeSDK_dynamic_framework/AwesomeSDKManager.h>
#import <AwesomeSDK_dynamic_framework/AwesomeManager_DF.h>

@implementation UseDynamicFrameworkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *frameworkPath = [[[NSBundle mainBundle] privateFrameworksPath] stringByAppendingPathComponent:@"AwesomeSDK_dynamic_framework.framework"];
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkPath];
    NSError *error;
    [frameworkBundle loadAndReturnError:&error];
    if (!frameworkBundle) {
        NSLog(@"not found framwork: %@", frameworkPath);
    }
    if (error) {
        NSLog(@"load framwork failed: %@", error);
    }
    //    [AwesomeSDKManager doSomething];
    [NSClassFromString(@"AwesomeSDKManager") doSomething];
    
    NSLog(@"------------------------------");
    [NSClassFromString(@"AwesomeManager_DF") doSomething];
}

@end
