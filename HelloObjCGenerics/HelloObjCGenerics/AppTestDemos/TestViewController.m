//
//  TestViewController.m
//  HelloObjCGenerics
//
//  Created by wesley_chen on 21/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "TestViewController.h"
#import "ItemContainer.h"

typedef void(^myBlock)(void);

@interface TestViewController ()
@property (nonatomic, strong) ItemContainer *container;
@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.container = [ItemContainer new];
    
//    float x = 10;
//    void (^block)(void) = ^{
//        NSLog(@"block called, %f", x);
//    };
//
//    [self.container addItem:block forKey:@"key"];
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self.container addItem:block forKey:@"key"];
//    });
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // @see https://stackoverflow.com/questions/35822645/understand-one-edge-case-of-block-memory-management-in-objc
    NSArray *tmp = [self getBlockArray];
    myBlock block = [tmp[2] copy];
    block();
}

- (id)getBlockArray {
    int val = 10;
    //crash version
    return [[NSArray alloc] initWithObjects:
            ^{NSLog(@"blk0:%d", val);},
            ^{NSLog(@"blk1:%d", val);},
            ^{NSLog(@"blk2:%d", val);},
            nil];
    //won't crash version
//        return @[^{NSLog(@"block0: %d", val);}, ^{NSLog(@"block1: %d", val);}];
}
@end
