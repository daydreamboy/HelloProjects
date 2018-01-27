//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "CheckBlockObjectViewController.h"
#import "WCBlockTool.h"

#define STR_OF_BOOL(yesOrNo)     ((yesOrNo) ? @"YES" : @"NO")

typedef long (^BlkSum)(int, int);
typedef void (^CompletionBlock)(void);

@implementation CheckBlockObjectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    void (^aBlock)(void) = ^{
        NSLog(@"something");
    };
    NSLog(@"is block: %@", STR_OF_BOOL([WCBlockTool isBlock:aBlock]));
    
    id object = [NSObject new];
    NSLog(@"is block: %@", STR_OF_BOOL([WCBlockTool isBlock:object]));
    
    void (^globalBlock)(void) = ^{
        NSLog(@"This is a __NSGlobalBlock__");
    };
    
    void (^mallocBlock)(void) = ^{
        NSLog(@"%@", self);
        NSLog(@"This is a __NSMallocBlock__");
    };
    
    void (^mallocBlock2)(BOOL enabled) = ^(BOOL enabled){
        NSLog(@"This is a __NSMallocBlock__");
    };
    
    [self test_with_block:mallocBlock];
    [self test_with_block:^{
        [self test_with_block:^{
            NSLog(@"sdfsa");
        }];
    }];
    
    int base = 100;
    BlkSum blk2 = ^ long (int a, int b) {
        return base + a + b;
    };
    NSLog(@"blk2 = %@", blk2); // blk2 = <__NSStackBlock__: 0xbfffddf8>
    
    NSLog(@"%@", globalBlock);
    NSLog(@"%@", mallocBlock2);
    NSLog(@"%@", ^(void){ NSLog(@"This is a __NSMallocBlock__"); });
}

#pragma mark - Test Methods

- (void)test_isBlock_with_ {
    
}

- (void)test_with_block:(void (^)(void))block {
    [self test_with_block2:block];
}

- (void)test_with_block2:(CompletionBlock)block {
    [self test_with_object:block];
}

- (void)test_with_object:(id)object {
    NSLog(@"object: %@", object);
}

@end
