//
//  GCCAttributeCleanupViewController.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/11/9.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GCCAttributeCleanupViewController.h"

void clean_up2(NSNumber **final_value)
{
    printf("Cleaning up2\n");
    NSLog(@"%@", *final_value);
}

void clean_up1(int* final_value)
{
    printf("Cleaning up1\n");
    printf("Final value: %d\n", *final_value);
}

@interface GCCAttributeCleanupViewController ()
@property (nonatomic, strong) NSNumber *number;
@end

@implementation GCCAttributeCleanupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_cleanup_primitive_type];
    [self test_cleanup_object];
    
    NSLog(@"number: %@", self.number);
}

#pragma mark - Test Methods

- (void)test_cleanup_object {
    __attribute__ ((cleanup(clean_up2))) NSNumber *aNumber = @(1);
    self.number = aNumber;
}

- (void)test_cleanup_primitive_type {
    int avar __attribute__ ((__cleanup__(clean_up1))) = 1;
    avar = 5;
    NSLog(@"%d", avar);
}

@end
