//
//  DepartmentDetailViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface Department2DetailViewController : BaseViewController
- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack department:(NSString *)department;

// For Testing
- (NSString *)totalEmployees;
- (NSString *)totalEmployeesFast;
- (NSString *)activeEmployees;
- (NSString *)activeEmployeesFast;

@end
