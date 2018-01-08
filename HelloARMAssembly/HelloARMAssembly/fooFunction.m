//
//  fooFunction.m
//  HelloARMAssembly
//
//  Created by wesley_chen on 07/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#include <stdio.h>

__attribute__((noinline))
int addFunction(int a, int b)
{
    int c = a + b;
    return c;
}

void fooFunction()
{
    int add = addFunction(12, 34);
    printf("add = %i", add);
}
