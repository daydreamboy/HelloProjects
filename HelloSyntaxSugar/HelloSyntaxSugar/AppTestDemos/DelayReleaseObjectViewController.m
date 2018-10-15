//
//  DelayReleaseObjectViewController.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/10/15.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DelayReleaseObjectViewController.h"

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
    // @see https://blog.ibireme.com/2015/11/12/smooth_user_interfaces_for_ios/
    MyObject *tempObject = _myObject;
    _myObject = nil;
    NSLog(@"start to dealloc");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // Note: use it to avoid warning
        [tempObject class];
    });
}

@end
