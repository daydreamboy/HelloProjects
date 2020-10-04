//
//  AlertWithTextViewController.m
//  AppTest
//
//  Created by wesley_chen on 10/01/2018.
//

#import "AlertWithTextViewController.h"
#import "WCAlertController.h"

@interface AlertWithTextViewController ()

@end

@implementation AlertWithTextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];

    [self showAlert:nil];
}

- (void)showAlert:(id)sender {
    static NSInteger alertCount = 1;
    
    NSString *message = [NSString stringWithFormat:@"This is your alert, you've show %ld alerts", (long)alertCount];
    WCAlertController *alert = [WCAlertController alertControllerWithTitle:@"Global Alert" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [alert show];
    alertCount++;
    
    // show a second Alert to simulate an Alert coming in from an unrelated part of your project
    if (alertCount % 2 == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self showAlert:nil];
        });
    }
}

@end
