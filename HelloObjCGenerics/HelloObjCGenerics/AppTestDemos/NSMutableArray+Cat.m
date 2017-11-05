//
//  NSMutableArray+Cat.m
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "NSMutableArray+Cat.h"
#import "Cat.h"

@implementation NSMutableArray (Cat)
- (id)giveMeACat {
    return [Cat new];
}
@end
