//
//  DelayReleaseObjectViewController.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/10/15.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DelayReleaseObjectViewController.h"

#define DELAY_RELEASE_AFTER(object_, seconds_, queue_) \
typeof(object_) tempObject__ = object_; \
object_ = nil; \
dispatch_queue_t release_queue__ = (queue_) == nil ? dispatch_get_main_queue() : (queue_); \
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds_ * NSEC_PER_SEC)), release_queue__, ^{ \
    [tempObject__ class]; \
});

@interface MyObject : NSObject
@end

@implementation MyObject
- (void)dealloc {
    NSLog(@"%@: dealloc called", self);
}
@end

@interface DelayReleaseObjectViewController ()
@property (nonatomic, strong) MyObject *myObject;
@end

@implementation DelayReleaseObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.myObject = [MyObject new];
}

- (void)dealloc {
    //[self test_safe_delay_release];
    [self test_safe_delay_release_by_macro];
    //[self test_bad_delay_release];
    //[self test_delay_release_not_work];
}

- (void)test_safe_delay_release {
    // @see https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/
    MyObject *tempObject = _myObject;
    _myObject = nil;
    NSLog(@"start to dealloc");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Note: use it to avoid warning
        [tempObject class];
    });
}

- (void)test_safe_delay_release_by_macro {
    DELAY_RELEASE_AFTER(_myObject, 3, nil);
}

- (void)test_bad_delay_release {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wimplicit-retain-self"
    NSLog(@"start to dealloc");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Crash: EXC_BAD_ACCESS
        _myObject = nil;
    });
#pragma GCC diagnostic pop
}

- (void)test_delay_release_not_work {
    // Crash: objc[31817]: Cannot form weak reference to instance (0x7f88a0919ea0) of class DelayReleaseObjectViewController. It is possible that this object was over-released, or is in the process of deallocation.
    __weak typeof(self) weak_self = self;
    NSLog(@"start to dealloc");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weak_self.myObject = nil;
    });
}

@end
