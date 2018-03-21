//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"

@interface Test : NSObject
@property (nonatomic, copy) NSString *string;
@end

@implementation Test
- (instancetype)init {
    [self doSomething];
    
    self = [super init];
    if (self) {
        NSLog(@"%@", self.string);
    }
    return self;
}
- (void)doSomething {
    _string = @"hello";
    NSLog(@"%@", self.string);
}
@end

@interface Demo1ViewController ()

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    Test *t = [Test new];
    NSLog(@"t: %@", t);
    
    [self test];
}

- (void)test {
    NSError *error;
    NSString *pattern;
    NSString *matchString;
    
    // Case 1
    // ￥1
    // ￥1.5
    // ￥1.5-20
    // ￥1.5-20.5
    
    pattern = @"￥(.+).";
    matchString = @"￥1";
    NSRegularExpression *exp = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    [exp enumerateMatchesInString:matchString options:kNilOptions range:NSMakeRange(0, matchString.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result == nil) return;
        
    }];
}

@end
