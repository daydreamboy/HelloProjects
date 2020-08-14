//
//  TaskHandler3.m
//  Tests
//
//  Created by wesley_chen on 2020/8/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "TaskHandler3.h"

@implementation TaskHandler3

- (instancetype)initWithBizKey:(NSString *)bizKey {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSString *)name {
    return @"taskHandlder3";
}

- (void)handleWithContext:(WCAsyncTaskChainContext *)context taskHandlerCompletion:(TaskHandlerCompletion)taskHandlerCompletion {
    if ([context.data isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithDictionary:context.data];
        dictM[@"taskHandler3"] = @"handled";
        
        taskHandlerCompletion(dictM, nil);
    }
}

@end
