//
//  Tests_weak_class1.m
//  Test_OC
//
//  Created by wesley_chen on 2021/5/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "Tests_weak_class1.h"

NSString * __attribute__((weak)) foo_maybe_exist_yet_another(void) {
    return NSStringFromClass([Tests_weak_class1 class]);
}

NSString * __attribute__((weak)) bar_maybe_exist_yet_another(void) {
    return NSStringFromClass([Tests_weak_class1 class]);
}

NSString * __attribute__((weak)) weak_bar_maybe_exist_yet_another(void) {
    return NSStringFromClass([Tests_weak_class1 class]);
}

@implementation Tests_weak_class1

@end
