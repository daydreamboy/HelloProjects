//
//  NSDictionary+CustomFunction.m
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NSDictionary+CustomFunction.h"

@implementation NSDictionary (CustomFunction)
- (id)elementForKey:(NSString *)key {
    return [self objectForKey:key];
}
@end
