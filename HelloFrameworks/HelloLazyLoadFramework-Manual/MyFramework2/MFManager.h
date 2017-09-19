//
//  MFManager.h
//  HelloLazyLoadFramework-Manual
//
//  Created by wesley_chen on 17/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagerBehavior.h"

@interface MFManager : NSObject
+ (void)hello;
+ (id<ManagerBehavior>)defaultManager;
@end
