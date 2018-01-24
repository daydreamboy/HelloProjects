//
//  WCCrashCaseTool.h
//  HelloCrash
//
//  Created by wesley_chen on 23/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCCrashCaseTool : NSObject

+ (void)makeCrashWithNilParameter;
+ (void)makeCrashWithArrayOutOfBound;
+ (void)makeCrashWithBadAccessReleasedPointer;
+ (void)makeCrashWithBadAccessNullPointer;

@end
