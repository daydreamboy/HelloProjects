//
//  NotificationSender.m
//  DynamicLibrary
//
//  Created by wesley_chen on 2018/5/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NotificationSender.h"
#import "Notifications.h"

@implementation NotificationSender
+ (void)load {
    [[NSNotificationCenter defaultCenter] postNotificationName:SomeNotification1 object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:SomeNotification2 object:nil];
}
@end
