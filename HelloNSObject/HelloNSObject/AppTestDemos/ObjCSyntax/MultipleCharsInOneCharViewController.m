//
//  MultipleCharsInOneCharViewController.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 12/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MultipleCharsInOneCharViewController.h"

@interface MultipleCharsInOneCharViewController ()

@end

@implementation MultipleCharsInOneCharViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_case1];
    [self test_case2];
}

- (void)test_case1 {
    // Note: multiple characters in char literal, compiler only get 4 bytes data from end to front
    // If multiple characters's size > 4 bytes, padding 0x00
    
    // @see // @see https://stackoverflow.com/questions/6944730/multiple-characters-in-a-character-constant
    unsigned value;
    char* ptr = (char*)&value;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmultichar"
    value = 'ABCD';
    printf("'ABCD' = %02x%02x%02x%02x = %08x\n", ptr[0], ptr[1], ptr[2], ptr[3], value);
    
    value = 'ABC';
    printf("'ABC'  = %02x%02x%02x%02x = %08x\n", ptr[0], ptr[1], ptr[2], ptr[3], value);
#pragma GCC diagnostic pop
}

- (void)test_case2 {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmultichar"
    int a = 'abcdef';
    int b = 'abcdef1234';
    long c = 'abcdef';
    long d = 'abcdef1234';
#pragma GCC diagnostic pop
    
    char *ptr;
    
    ptr = (char *)&a;
    printf("'abcdef' = %02x%02x%02x%02x = %08x\n", ptr[0], ptr[1], ptr[2], ptr[3], a);
    
    ptr = (char *)&b;
    printf("'abcdef1234' = %02x%02x%02x%02x = %08x\n", ptr[0], ptr[1], ptr[2], ptr[3], b);
    
    ptr = (char *)&c;
    printf("'abcdef' = %02x%02x%02x%02x = %08lx\n", ptr[0], ptr[1], ptr[2], ptr[3], c);
    
    ptr = (char *)&d;
    printf("'abcdef1234' = %02x%02x%02x%02x = %08lx\n", ptr[0], ptr[1], ptr[2], ptr[3], d);
}

@end
