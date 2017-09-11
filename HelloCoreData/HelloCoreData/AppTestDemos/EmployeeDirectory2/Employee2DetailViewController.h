//
//  Employee2DetailViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee2+CoreDataClass.h"

@interface Employee2DetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *headShotImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *departmentLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *startDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *vacationDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *salesCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *bioTextView;

- (instancetype)initWithEmployee:(Employee2 *)employee;
@end
