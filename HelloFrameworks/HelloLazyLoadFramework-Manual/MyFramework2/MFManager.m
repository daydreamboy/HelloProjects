//
//  MFManager.m
//  HelloLazyLoadFramework-Manual
//
//  Created by wesley_chen on 17/09/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "MFManager.h"
#import <Contacts/Contacts.h>

@interface Manager2 : NSObject <ManagerBehavior>

@end

@implementation Manager2
- (NSString *)defaultName {
    return @"Manager2 (MyFramework2)";
}
@end

@implementation MFManager

+ (void)load {
    NSLog(@"loading MFManager from MyFramework2");
}

+ (void)hello {
    CNMutableContact *contact = [CNMutableContact new];
    BOOL output = NO;
    if (output) {
        NSLog(@"%@", contact);
    }
    
    NSLog(@"Hello from MyFramework2");
}

+ (id<ManagerBehavior>)defaultManager {
    return [Manager2 new];
}

@end
