//
//  Test_ffi_call.m
//  Test
//
//  Created by wesley_chen on 2019/6/5.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <libffi/ffi.h>

int fun1 (int a, int b) {
    printf("fun1 called\n");
    return a + b;
}

int fun2 (int a, int b) {
    printf("fun2 called\n");
    return 2 * a + b;
}

@interface Test_ffi_call : XCTestCase

@end

@implementation Test_ffi_call

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test {
    ffi_type **types;  // 参数类型
    types = malloc(sizeof(ffi_type *) * 2) ;
    types[0] = &ffi_type_sint;
    types[1] = &ffi_type_sint;
    ffi_type *retType = &ffi_type_sint;
    
    void **args = malloc(sizeof(void *) * 2);
    int x = 1, y = 2;
    args[0] = &x;
    args[1] = &y;
    
    int ret;
    
    ffi_cif cif;
    // 生成模板
    ffi_prep_cif(&cif, FFI_DEFAULT_ABI, 2, retType, types);
    // 动态调用fun1
    ffi_call(&cif, fun1,  &ret, args);
}

@end
