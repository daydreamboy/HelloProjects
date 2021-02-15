//
//  SharedTool.m
//  SharedLibrary
//
//  Created by wesley_chen on 2021/2/15.
//

#import "SharedTool.h"

@implementation SharedTool

+ (nullable UIApplication *)getSharedApplication {
#if COCOAPODS
//#error "compile by cocoapods"
    id object = nil;
    if ([UIApplication respondsToSelector:@selector(sharedApplication)]) {
        object = [UIApplication performSelector:@selector(sharedApplication)];
    }
    return object;
#else
//#error "compile not by cocoapods"
    return UIApplication.sharedApplication;
#endif
}

@end
