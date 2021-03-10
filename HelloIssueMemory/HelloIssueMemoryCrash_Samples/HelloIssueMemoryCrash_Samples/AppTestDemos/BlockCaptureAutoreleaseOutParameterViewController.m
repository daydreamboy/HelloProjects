//
//  BlockCaptureAutoreleaseOutParameterViewController.m
//  HelloIssueMemoryCrash_Samples
//
//  Created by wesley_chen on 2021/3/9.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "BlockCaptureAutoreleaseOutParameterViewController.h"

@interface BlockCaptureAutoreleaseOutParameterViewController ()

@end

@implementation BlockCaptureAutoreleaseOutParameterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test_issue_fixed];
    [self test_issue];
}

- (void)test_issue {
    // @see http://yulingtianxia.com/blog/2017/07/17/What-s-New-in-LLVM-2017/
    // @see https://asciiwwdc.com/2018/sessions/409
    NSError *error = nil;
    [self validateDictionary:@{@"key": @"value"} error:&error];
}

- (void)validateDictionary:(NSDictionary<NSString *, NSString *> *)dict error:(NSError **)error {
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            if (error) { // // warning: block captures an autoreleasing out-parameter, which may result in use-after-free bugs
                *error = [NSError errorWithDomain:@"FishDomain" code:0 userInfo:nil];
            }
        }
    }];
}

- (void)test_issue_fixed {
    // @see http://yulingtianxia.com/blog/2017/07/17/What-s-New-in-LLVM-2017/
    // @see https://asciiwwdc.com/2018/sessions/409
    NSError *error = nil;
    [self fixed_validateDictionary:@{@"key": @"value"} error:&error];
}

- (void)fixed_validateDictionary:(NSDictionary<NSString *, NSString *> *)dict error:(NSError **)error {
    __block NSError *strongError = nil;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.length > 0) {
            strongError = [NSError errorWithDomain:@"FishDomain" code:0 userInfo:nil];
        }
    }];
    if (error) {
        *error = strongError;
    }
}

@end
