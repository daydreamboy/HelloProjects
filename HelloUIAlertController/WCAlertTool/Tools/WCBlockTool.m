//
//  WCBlockTool.m
//  HelloUIAlertController
//
//  Created by wesley_chen on 2019/2/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCBlockTool.h"

@implementation WCBlockTool

+ (BOOL)isBlock:(id _Nullable)object {
    static Class blockClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blockClass = [^{} class];
        while ([blockClass superclass] != [NSObject class]) {
            blockClass = [blockClass superclass];
        }
    });
    
    return [object isKindOfClass:blockClass];
}

@end
