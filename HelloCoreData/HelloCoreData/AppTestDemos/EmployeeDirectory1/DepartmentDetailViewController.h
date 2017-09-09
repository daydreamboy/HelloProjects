//
//  DepartmentDetailViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 09/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface DepartmentDetailViewController : BaseViewController
- (instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack department:(NSString *)department;
@end
