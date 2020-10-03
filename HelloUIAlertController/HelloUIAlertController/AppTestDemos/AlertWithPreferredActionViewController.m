//
//  AlertWithPreferredActionViewController.m
//  HelloUIAlertController
//
//  Created by wesley_chen on 2020/10/3.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "AlertWithPreferredActionViewController.h"

@interface AlertWithPreferredActionViewController ()

@end

@implementation AlertWithPreferredActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"The confirm button is the preferred action" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
    }]];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:confirmAction];
    
    // @see https://stackoverflow.com/a/44013811
    alert.preferredAction = confirmAction;
    
    [self presentViewController:alert animated:YES completion:nil];
    
}



@end
