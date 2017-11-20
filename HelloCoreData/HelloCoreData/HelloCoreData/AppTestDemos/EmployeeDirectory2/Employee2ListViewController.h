//
//  Employee2ListViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 11/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface Employee2ListViewController : BaseViewController
/// get its coreData and context before call this method
- (void)prepareContextAndCoreData;

/// instantiate the employee list under the same department
- (instancetype)initWithDepartment:(NSString *)department;

@end
