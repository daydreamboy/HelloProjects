//
//  WCThrottleTool.m
//  HelloFRP
//
//  Created by wesley_chen on 2021/6/10.
//

#import "WCThrottleTool.h"
#import "WCThreadSafeDictionary.h"

#define kSeparator @"$"
#define kAccessKey(bizKey, uniqueKey) [NSString stringWithFormat:@"%@%@%@", kSeparator, bizKey, uniqueKey]

@interface WCThrottleTool ()
@property (nonatomic, strong, class, readonly) WCThreadSafeDictionary *timestampsKeeper;
@end

@implementation WCThrottleTool

+ (BOOL)checkTimestampOutdateWithUniqueKey:(NSString *)uniqueKey forBizKey:(NSString *)bizKey timeGap:(NSTimeInterval)timeGap {
    if (![uniqueKey isKindOfClass:[NSString class]] || ![bizKey isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (uniqueKey.length == 0 || bizKey.length == 0) {
        return NO;
    }
    
    NSString *accessKey = kAccessKey(bizKey, uniqueKey);
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSNumber *number = [[self timestampsKeeper] objectForKey:accessKey];
    NSTimeInterval lastTimestamp = ({
        NSTimeInterval timestamp = 0;
        if ([number isKindOfClass:[NSNumber class]]) {
            timestamp = [number doubleValue];
        }
        timestamp;
    });
    
    // Note: check valid parameter
    // 1. lastTimestamp must greater than 0
    // 2. now must greater than lastTimestamp
    // 3. lastTimestamp is outdated when now - lastTimestamp < timeGap
    if (lastTimestamp > 0 && now - lastTimestamp > 0 && now - lastTimestamp < timeGap) {
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)markTimestampWithUniqueKey:(NSString *)uniqueKey forBizKey:(NSString *)bizKey {
    if (![uniqueKey isKindOfClass:[NSString class]] || ![bizKey isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (uniqueKey.length == 0 || bizKey.length == 0) {
        return NO;
    }
    
    NSString *accessKey = kAccessKey(bizKey, uniqueKey);
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    [[self timestampsKeeper] setObject:@(now) forKey:accessKey];
    
    return YES;
}

+ (BOOL)clearTimestampWithUniqueKey:(NSString *)uniqueKey forBizKey:(NSString *)bizKey {
    if (![uniqueKey isKindOfClass:[NSString class]] || ![bizKey isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (uniqueKey.length == 0 || bizKey.length == 0) {
        return NO;
    }
    
    NSString *accessKey = kAccessKey(bizKey, uniqueKey);
    [[self timestampsKeeper] removeObjectForKey:accessKey];
    
    return YES;
}

+ (BOOL)clearAllTimestampsForBizKey:(NSString *)bizKey {
    if (![bizKey isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (bizKey.length == 0) {
        return NO;
    }
    
    NSArray<NSString *> *keys = [[self timestampsKeeper] allKeys];
    NSMutableArray *toRemove = [NSMutableArray arrayWithCapacity:keys.count];
    
    NSString *prefix = [[NSString alloc] initWithFormat:@"%@%@", bizKey, kSeparator];
    [keys enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj hasPrefix:prefix]) {
            [toRemove addObject:obj];
        }
    }];
    
    if (toRemove.count) {
        [[self timestampsKeeper] removeObjectsForKeys:toRemove];
    }
    
    return YES;
}

+ (BOOL)clearAllTimestamps {
    [[self timestampsKeeper] removeAllObjects];
    
    return YES;
}

#pragma mark - Getter

static WCThreadSafeDictionary *sTimestampsKeeper;

+ (WCThreadSafeDictionary *)timestampsKeeper {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sTimestampsKeeper = [[WCThreadSafeDictionary alloc] initWithCapacity:100];
    });
    
    return sTimestampsKeeper;
}

@end
