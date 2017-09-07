//
//  BaseViewController.h
//  HelloCoreData
//
//  Created by wesley_chen on 30/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreDataStack.h"

@interface BaseViewController : UIViewController
@property (nonatomic, strong) CoreDataStack *coreDataStack;
@end
