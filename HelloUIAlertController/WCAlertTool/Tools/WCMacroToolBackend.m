//
//  WCMacroToolBackend.m
//  HelloUIAlertController
//
//  Created by wesley_chen on 2019/3/9.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCMacroToolBackend.h"

@implementation WCMacroToolBackend

+ (NSArray *)arrayFromVaList:(va_list)ap {
    id obj;
    NSMutableArray *array = [NSMutableArray array];
    
    while ((obj = va_arg(ap, id))) {
        [array addObject:obj];
    }
    
    return array;
}

@end
