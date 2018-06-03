//
//  DefineCustomSectionInMachOFileViewController.m
//  HelloAttributeSection
//
//  Created by wesley_chen on 2018/6/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "DefineCustomSectionInMachOFileViewController.h"

// @see https://stackoverflow.com/a/22366882
extern int start_mysection __asm("section$start$__DATA$__mysection");
extern int stop_mysection  __asm("section$end$__DATA$__mysection");

// If you don't reference x, y and z explicitly, they'll be dead-stripped.
// Prevent that with the "used" attribute.
static int x __attribute__((used,section("__DATA,__mysection"))) = 4;
static int y __attribute__((used,section("__DATA,__mysection"))) = 10;
static int z __attribute__((used,section("__DATA,__mysection"))) = 22;


extern char* start_mysection2 __asm("section$start$__DATA$__mysection2");
extern char* stop_mysection2  __asm("section$end$__DATA$__mysection2");
static char *str1 __attribute__((used,section("__DATA,__mysection2"))) = "str1";
static char *str2 __attribute__((used,section("__DATA,__mysection2"))) = "str2";

@interface DefineCustomSectionInMachOFileViewController ()

@end

@implementation DefineCustomSectionInMachOFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
    [self test2];
}

- (void)test1 {
    long sz = &stop_mysection - &start_mysection;
    long i;
    
    printf("Section size is %ld\n", sz);
    
    for (i=0; i < sz; ++i) {
        printf("%d\n", (&start_mysection)[i]);
    }
}

- (void)test2 {
    long sz = &stop_mysection2 - &start_mysection2;
    long i;
    
    printf("Section size is %ld\n", sz);
    
    for (i=0; i < sz; ++i) {
        printf("%s\n", (&start_mysection2)[i]);
    }
}

@end
