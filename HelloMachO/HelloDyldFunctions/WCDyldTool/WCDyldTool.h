//
//  WCDyldTool.h
//  HelloDyldFunctions
//
//  Created by wesley_chen on 2018/8/13.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, DYLD_OPTIONS) {
    DYLD_PRINT_LIBRARIES = 1 << 0,
};

@interface WCDyldTool : NSObject

+ (void)registerDynamicLibraresDidLoad;
+ (void)registerDynamicLibraresDidUnload;

@end

NS_ASSUME_NONNULL_END
