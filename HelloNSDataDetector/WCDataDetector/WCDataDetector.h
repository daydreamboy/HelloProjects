//
//  WCDataDetector.h
//  HelloNSDataDetector
//
//  Created by wesley_chen on 2018/7/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCDataDetector : NSObject

/**
 Allow to cache the match result
 
 Default is YES.
 */
@property (nonatomic, assign) BOOL enableCheckResultsCache;

/**
 The number of cache object entries
 
 Default is 50
 */
@property (nonatomic, assign) NSUInteger cacheCountLimit;

/**
 The checking types when initialized
 */
@property (nonatomic, readonly) NSTextCheckingTypes checkingTypes;

- (instancetype)initWithTypes:(NSTextCheckingTypes)checkingTypes error:(NSError * _Nullable *)error;

- (NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)string options:(NSMatchingOptions)options;
- (void)asyncMatchesInString:(NSString *)string options:(NSMatchingOptions)options completion:(void (^)(NSArray<NSTextCheckingResult *> *))completion;

@end

NS_ASSUME_NONNULL_END
