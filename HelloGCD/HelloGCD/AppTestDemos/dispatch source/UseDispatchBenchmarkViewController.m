//
//  UseDispatchBenchmarkViewController.m
//  HelloGCD
//
//  Created by wesley_chen on 2017/10/3.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "UseDispatchBenchmarkViewController.h"
#import <sys/socket.h> // for socket()
#import <netinet/in.h> // for IPPROTO_TCP

// Warning: this is private function
extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

//#define DEBUG 0

// @see http://www.jianshu.com/p/65876dbd0d05
#if DEBUG
extern uint64_t dispatch_benchmark(size_t count, void (^block)(void));

#define WC_MeasureWithBlock(name, func_body) \
do { \
    uint64_t nanoSeconds = dispatch_benchmark(10000, ^{ \
        @autoreleasepool { \
            { ^func_body(); } \
        } \
    }); \
    NSLog(@"[Benchmark] <%@> The average time for operation is %llu ns.", name, nanoSeconds); \
} while (0)

#else
#define WC_MeasureWithBlock(name, func_body)
#endif

@interface UseDispatchBenchmarkViewController ()
@property (nonatomic, strong) dispatch_queue_t isolation;
@end

@implementation UseDispatchBenchmarkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // @see https://www.objc.io/issues/2-concurrency/low-level-concurrency-apis/#benchmarking
    // @see http://nshipster.com/benchmarking/
    
    [self test_dispatch_benchmark];
    [self test_dispatch_benchmark_with_macro];
}

#pragma mark - Test Methods

- (void)test_dispatch_benchmark {
    static size_t const count = 1000;
    static size_t const iterations = 10000;
    
    uint64_t t_0 = dispatch_benchmark(iterations, ^{
        @autoreleasepool {
            id object = @42;
            NSMutableArray *mutableArray = [NSMutableArray array];
            for (size_t i = 0; i < count; i++) {
                [mutableArray addObject:object];
            }
        }
    });
    NSLog(@"[[NSMutableArray array] addObject:] Avg. Runtime: %llu ns", t_0);
    
    uint64_t t_1 = dispatch_benchmark(iterations, ^{
        @autoreleasepool {
            id object = @42;
            NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:count];
            for (size_t i = 0; i < count; i++) {
                [mutableArray addObject:object];
            }
        }
    });
    NSLog(@"[[NSMutableArray arrayWithCapacity] addObject:] Avg. Runtime: %llu ns", t_1);
}

- (void)test_dispatch_benchmark_with_macro {
    static size_t const count = 1000;
    
    WC_MeasureWithBlock(@"[[NSMutableArray array] addObject:]", {
        id object = @42;
        NSMutableArray *mutableArray = [NSMutableArray array];
        for (size_t i = 0; i < count; i++) {
            [mutableArray addObject:object];
        }
    });
    
    WC_MeasureWithBlock(@"[[NSMutableArray arrayWithCapacity] addObject:]", {
        id object = @42;
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:count];
        for (size_t i = 0; i < count; i++) {
            [mutableArray addObject:object];
        }
    });
}

@end
