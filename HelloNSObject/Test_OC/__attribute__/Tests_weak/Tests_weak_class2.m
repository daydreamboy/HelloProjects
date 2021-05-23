//
//  Tests_weak_class2.m
//  Test_OC
//
//  Created by wesley_chen on 2021/5/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "Tests_weak_class2.h"

NSString *foo_maybe_exist_yet_another(void) {
    return NSStringFromClass([Tests_weak_class2 class]);
}

NSString *bar_maybe_exist_yet_another(void) {
    return NSStringFromClass([Tests_weak_class2 class]);
}

NSString * __attribute__((weak)) weak_bar_maybe_exist_yet_another(void) {
    return NSStringFromClass([Tests_weak_class2 class]);
}

@implementation Tests_weak_class2

@end
