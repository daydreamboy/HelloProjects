//
//  DepartmentListViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 07/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CoreDataStack.h"

@interface Department2ListViewController : BaseViewController
- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack;

// For Testing
- (NSArray<NSDictionary<NSString *, NSString *> *> *)totalEmployeesPerDepartment;
- (NSArray<NSDictionary<NSString *, NSString *> *> *)totalEmployeesPerDepartmentFast;
@end
