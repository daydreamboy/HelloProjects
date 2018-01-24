//
//  WCUncaughtExceptionTool.h
//  HelloCrash
//
//  Created by wesley_chen on 23/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (*signal_handler_t)(int);

@interface WCUncaughtExceptionTool : NSObject

+ (void)installUncaughtExceptionHandler;
+ (NSString *)signalNameWithSignal:(int)signal;

@end
