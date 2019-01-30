//
//  UseNSCacheViewController.m
//  HelloNSCache
//
//  Created by wesley_chen on 2019/1/30.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseNSCacheViewController.h"

@interface UseNSCacheViewController () <NSCacheDelegate>
@property (nonatomic, strong) NSCache *cache;
@end

@implementation UseNSCacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.cache = [NSCache new];
    [self test_countLimit_of_NSCache];
}

- (void)test_countLimit_of_NSCache {
    NSString *string;
    
    self.cache.delegate = self;
    self.cache.countLimit = 2;
    
    [self.cache setObject:@"3" forKey:@"3" cost:3];
    [self.cache setObject:@"2" forKey:@"2" cost:2];
    
    
    [self.cache setObject:@"1" forKey:@"1" cost:1];
    
    string = [self.cache objectForKey:@"3"];
    NSLog(@"%@", string);
    
    string = [self.cache objectForKey:@"1"];
    NSLog(@"%@", string);
    
    string = [self.cache objectForKey:@"2"];
    NSLog(@"%@", string);
}

- (void)test_totalCostLimit_of_NSCache {
    NSString *string;
    
    self.cache.delegate = self;
    self.cache.totalCostLimit = 5;
    
    [self.cache setObject:@"3" forKey:@"3" cost:3];
    [self.cache setObject:@"2" forKey:@"2" cost:2];
    
    [self.cache setObject:@"1" forKey:@"1" cost:1];
    
    string = [self.cache objectForKey:@"3"];
    NSLog(@"%@", string);
    
    string = [self.cache objectForKey:@"1"];
    NSLog(@"%@", string);
    
    string = [self.cache objectForKey:@"2"];
    NSLog(@"%@", string);
}

#pragma mark - NSCacheDelegate

- (void)cache:(NSCache *)cache willEvictObject:(id)obj {
    NSLog(@"willEvictObject: %@", obj);
}

@end
