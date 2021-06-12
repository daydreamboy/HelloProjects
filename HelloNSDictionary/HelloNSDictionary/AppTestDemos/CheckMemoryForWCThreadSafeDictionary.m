//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "CheckMemoryForWCThreadSafeDictionary.h"
#import "WCThreadSafeDictionary.h"
#import "MyKey.h"
#import "MyValue.h"

@interface CheckMemoryForWCThreadSafeDictionary ()
@property (nonatomic, strong) WCThreadSafeDictionary<NSString *, NSString *> *cache;
@end

@implementation CheckMemoryForWCThreadSafeDictionary

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cache = [WCThreadSafeDictionary dictionary];
    
    [self test_allKeys_memory];
}

- (void)test_allKeys_memory {
    WCThreadSafeDictionary<NSString *, NSString *> *cache = self.cache;
    
    __weak id weakKey = nil;
    __weak id weakValue = nil;
    {
        id key = [[MyKey alloc] init];
        id value = [[MyValue alloc] init];
        weakKey = key;
        weakValue = value;
        
        cache[key] = value;
        
        NSString *firstKey = [[cache allKeys] firstObject];
        [cache removeObjectForKey:firstKey];
    }
    
    // Note: key and value not release synchorously, so check weakKey and weakValue after some seconds
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSAssert(weakKey == nil, @"weakKey");
        NSAssert(weakValue == nil, @"weakValue");
    });
}

@end
