//
//  NaNViewController.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/4/18.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NaNViewController.h"

@interface NaNViewController ()

@end

@implementation NaNViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test_isnan_with_nan];
}

- (void)test_isnan_with_nan {
    double maybeNumber;
    
    maybeNumber = nan(NULL);
    NSLog(@"%f", maybeNumber);
    
    CGRect rect = CGRectMake(maybeNumber, maybeNumber, maybeNumber, maybeNumber);
    NSLog(@"%@", NSStringFromCGRect(rect));
    
    // Note: isnan return 0 indicates it's a double number
    if (isnan(maybeNumber) == 0) {
        NSLog(@"a number");
    }
    else {
        NSLog(@"not a number");
    }
    
    maybeNumber = 3.14;
    NSLog(@"%f", maybeNumber);
    
    if (isnan(maybeNumber) == 0) {
        NSLog(@"a number");
    }
    else {
        NSLog(@"not a number");
    }
    
    int integer = 4;
    NSLog(@"%d", integer);
    
    if (isnan(integer) == 0) {
        NSLog(@"a number");
    }
    else {
        NSLog(@"not a number");
    }
    
    float maybeFloat = NAN;
    if (isnan(maybeFloat) == 0) {
        NSLog(@"a number");
    }
    else {
        NSLog(@"not a number");
    }
}

@end
