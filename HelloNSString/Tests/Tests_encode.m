//
//  Tests_encode.m
//  Tests
//
//  Created by wesley_chen on 2018/9/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_encode : XCTestCase

@end

@implementation Tests_encode

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#define WCDumpBool(var)   NSLog(@"%@:%@: `%s`= %@", @(__FILE_NAME__), @(__LINE__), #var, (var))

- (void)test_encode {
    NSLog(@"%s", @encode(double));
    NSLog(@"%s", @encode(float));
    NSLog(@"%s", @encode(int));
    NSLog(@"%s", @encode(NSInteger));
    NSLog(@"%s", @encode(long));
    NSLog(@"%s", @encode(long long));
    NSLog(@"%s", @encode(BOOL));
    
    // Example 1: Scalar types
    printf("%s\n", @encode(int)); // i, unsigned i for I
    printf("%s\n", @encode(short)); // s, unsiged s for S
    printf("%s\n", @encode(unsigned int)); // I, Upper case for unsigned
    printf("%s\n", @encode(long long)); // q, unsigned q for Q
    printf("%s\n", @encode(double)); // d
    printf("%s\n", @encode(long double)); // D
    printf("%s\n", @encode(BOOL)); // c, typedef signed char BOOL;
    printf("%s\n", @encode(void)); // v
    printf("%s\n", @encode(void *)); // v^
    printf("%s\n", @encode(char *)); // *, NOT c^
    printf("%s\n", @encode(float **)); // ^^f
    printf("%s\n", @encode(Class)); // #
    printf("%s\n", @encode(id)); // @
    printf("%s\n", @encode(SEL)); // :
    printf("%s\n", @encode(IMP)); // ^?
    printf("%s\n", @encode(char (*)(long))); // ^?
    printf("---------------------------\n");
    
    // Example 2: Complex types
    printf("%s\n", @encode(char *[10])); // [10*]
    printf("%s\n", @encode(int [10])); // [10i]
    printf("%s\n", @encode(float *[10])); // [10^f]
    printf("%s\n", @encode(struct s { int b; })); // {s=i}
    printf("%s\n", @encode(struct field { int bit : 3; })); // {field=b3}
    printf("%s\n", @encode(union u { char ch; })); // (u=c)
    printf("%s\n", @encode(struct s *)); // ^{s=i}
    printf("%s\n", @encode(struct field *)); // ^{field=b3}
    printf("%s\n", @encode(union u *)); // ^(u=c)
    printf("%s\n", @encode(struct s **)); // ^^{s}, no data member type for secondary pointer
}

@end
