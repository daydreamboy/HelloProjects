//
//  GenericSelectionExpressionViewController.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/4/23.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "GenericSelectionExpressionViewController.h"

// @see http://www.robertgamble.net/2012/01/c11-generic-selections.html
@interface GenericSelectionExpressionViewController ()

@end

@implementation GenericSelectionExpressionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test_generic_printnl];
    [self test_generic_typename];
}

#define printf_dec_format(x) _Generic((x), \
    char: "%c", \
    signed char: "%hhd", \
    unsigned char: "%hhu", \
    signed short: "%hd", \
    unsigned short: "%hu", \
    signed int: "%d", \
    unsigned int: "%u", \
    long int: "%ld", \
    unsigned long int: "%lu", \
    long long int: "%lld", \
    unsigned long long int: "%llu", \
    float: "%f", \
    double: "%f", \
    long double: "%Lf", \
    char *: "%s", \
    void *: "%p")

#define print(x) printf(printf_dec_format(x), x)
#define printnl(x) printf(printf_dec_format(x), x), printf("\n");

- (void)test_generic_printnl {
    printnl('a');    // prints "97" (on an ASCII system)
    printnl((char)'a');  // prints "a"
    printnl(123);    // prints "123"
    printnl(1.234);      // prints "1.234000"
}

/* Get the name of a type */
#define typename(x) _Generic((x), _Bool: "_Bool", \
    char: "char", \
    signed char: "signed char", \
    unsigned char: "unsigned char", \
    short int: "short int", \
    unsigned short int: "unsigned short int", \
    int: "int", \
    unsigned int: "unsigned int", \
    long int: "long int", \
    unsigned long int: "unsigned long int", \
    long long int: "long long int", \
    unsigned long long int: "unsigned long long int", \
    float: "float", \
    double: "double", \
    long double: "long double", \
    char *: "pointer to char", \
    void *: "pointer to void", \
    int *: "pointer to int", \
    default: "other")

- (void)test_generic_typename {
    size_t s;
    ptrdiff_t p;
    intmax_t i;
 
    int ai[3] = {0};
 
    printf("size_t is '%s'\n", typename(s));
    printf("ptrdiff_t is '%s'\n", typename(p));
    printf("intmax_t is '%s'\n", typename(i));
 
    printf("character constant is '%s'\n", typename('0'));
    printf("0x7FFFFFFF is '%s'\n", typename(0x7FFFFFFF));
    printf("0xFFFFFFFF is '%s'\n", typename(0xFFFFFFFF));
    printf("0x7FFFFFFFU is '%s'\n", typename(0x7FFFFFFFU));
    printf("array of int is '%s'\n", typename(ai));
}

@end
