//
//  EmployeePictureViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Employee1+CoreDataClass.h"

@interface EmployeePictureViewController : UIViewController
- (instancetype)initWithEmployee:(Employee1 *)employee;
@end
