//
//  WCCrashCaseTool.m
//  HelloCrash
//
//  Created by wesley_chen on 23/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCCrashCaseTool.h"

@implementation WCCrashCaseTool

+ (void)makeCrashWithNilParameter {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wnonnull"
    [[NSMutableArray array] addObject:nil]; // Note: will crash
#pragma GCC diagnostic pop
}

+ (void)makeCrashWithArrayOutOfBound {
    [[NSArray array] objectAtIndex:0]; // Note: will crash
}

+ (void)makeCrashWithBadAccessReleasedPointer {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Warc-unsafe-retained-assign"
    __unsafe_unretained NSObject *object;
    {
        object = [[NSObject alloc] init];
    }
#pragma GCC diagnostic pop

    NSLog(@"%@", [object description]); // Note: will crash
}

+ (void)makeCrashWithBadAccessNullPointer {
    void (*nullFunction)(void) = NULL;
    nullFunction(); // Note: will crash
}

@end
