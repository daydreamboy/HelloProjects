//
//  UseSignalHandlerViewController.h
//  HelloCrash
//
//  Created by wesley_chen on 23/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewController.h"

#define SignalLogFileName @"Signal_Log.txt"
#define SignalLogFilePath ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:SignalLogFileName])

@interface UseSignalHandlerViewController : BaseTableViewController

@end
