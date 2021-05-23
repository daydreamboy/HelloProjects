//
//  Tests_weak_class1.h
//  Test_OC
//
//  Created by wesley_chen on 2021/5/23.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

NSString *foo_maybe_exist_yet_another(void) __attribute__((weak));
NSString *bar_maybe_exist_yet_another(void) __attribute__((weak));
NSString *weak_bar_maybe_exist_yet_another(void) __attribute__((weak));

@interface Tests_weak_class1 : NSObject

@end

NS_ASSUME_NONNULL_END
