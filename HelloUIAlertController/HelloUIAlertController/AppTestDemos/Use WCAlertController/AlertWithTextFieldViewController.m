//
//  AlertWithTextFieldViewController.m
//  AppTest
//
//  Created by wesley_chen on 10/01/2018.
//

#import "AlertWithTextFieldViewController.h"
#import "WCAlertController.h"

@interface AlertWithTextFieldViewController ()

@end

@implementation AlertWithTextFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self showAlertField:nil];
}

- (void)showAlertField:(id)sender {
    // need local variable for TextField to prevent retain cycle of Alert otherwise UIWindow
    // would not disappear after the Alert was dismissed
    __block UITextField *localTextField;
    WCAlertController *alert = [WCAlertController alertControllerWithTitle:@"Global Alert" message:@"Enter some text" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSLog(@"do something with text: %@", localTextField.text);
    }]];
    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField) {
        localTextField = textField;
    }];
    [alert show];
}

@end
