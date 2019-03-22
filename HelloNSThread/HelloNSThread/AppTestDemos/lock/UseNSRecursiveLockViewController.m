//
//  UseNSRecursiveLockViewController.m
//  HelloNSThread
//
//  Created by wesley_chen on 2019/3/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "UseNSRecursiveLockViewController.h"

@interface UseNSRecursiveLockViewController ()
@property (nonatomic, strong) NSRecursiveLock *rLock;
@end

@implementation UseNSRecursiveLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.rLock = [[NSRecursiveLock alloc] init];
    self.rLock.name = @"My Recursive Lock";
    
    // Note: random json data from https://www.json-generator.com/
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"randomJSON" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    
    [NSThread detachNewThreadSelector:@selector(printJSONObjectRecursively:) toTarget:self withObject:JSONObject];
    [NSThread detachNewThreadSelector:@selector(printJSONObjectRecursively:) toTarget:self withObject:JSONObject];
}

- (void)printJSONObjectRecursively:(id)JSONObject {
    [self.rLock lock]; // Note: Ok, lock again without unlock is safe for the same thread
    
    if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        for (NSString *key in [(NSDictionary *)JSONObject allKeys]) {
            [self printJSONObjectRecursively:JSONObject[key]];
        }
    }
    else if ([JSONObject isKindOfClass:[NSArray class]]) {
        for (id object in JSONObject) {
            [self printJSONObjectRecursively:object];
        }
    }
    else {
        printf("Thread %p print: <%p: %s>\n", [NSThread currentThread], JSONObject, [JSONObject description].UTF8String);
        usleep(1);
    }
    
    [self.rLock unlock];
}

@end
