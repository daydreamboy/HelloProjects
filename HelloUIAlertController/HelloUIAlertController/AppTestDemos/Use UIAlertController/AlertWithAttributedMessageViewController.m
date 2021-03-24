//
//  AlertWithAttributedMessageViewController.m
//  HelloUIAlertController
//
//  Created by wesley_chen on 2021/3/24.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "AlertWithAttributedMessageViewController.h"

@interface AlertWithAttributedMessageViewController ()

@end

@implementation AlertWithAttributedMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"The confirm button is the preferred action" message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
    }]];
    
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    
    [alert addAction:confirmAction];
    
    // @see https://medium.com/@chauyan/change-text-alignment-of-the-uialertviewcontroller-af25bce05af1
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentLeft;
     
    NSMutableAttributedString *messageText = [[NSMutableAttributedString alloc] initWithString:@"Left Position, correct?" attributes:@{
        NSParagraphStyleAttributeName: paragraphStyle,
        NSFontAttributeName: [UIFont preferredFontForTextStyle:UIFontTextStyleBody],
        NSForegroundColorAttributeName: [UIColor orangeColor],
    }];
    
    [alert setValue:messageText forKey:@"attributedMessage"];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
