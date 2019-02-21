//
//  MPMDataDetector.h
//  MPMessageContainer
//
//  Created by wesley_chen on 2018/7/29.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_OPTIONS(NSUInteger, MPMDataDetectorCheckResultType) {
    MPMDataDetectorCheckResultTypeUnknown = 1 << 0,
    MPMDataDetectorCheckResultTypeLink = 1 << 1,
    MPMDataDetectorCheckResultTypePhoneNumber = 1 << 2,
    MPMDataDetectorCheckResultTypeEmoticon = 1 << 3,
};

@interface MPMDataDetectorCheckResult : NSObject
@property (nonatomic, assign) NSRange range;
@property (nonatomic, assign) MPMDataDetectorCheckResultType type;
@property (nonatomic, strong) NSString *matchString;
@property (nonatomic, strong) NSURL *URL;
@end

@interface MPMDataDetector : NSObject

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
@property (nonatomic, readonly) MPMDataDetectorCheckResultType checkingTypes;

/**
 The pattern for emoticon code
 */
@property (nonatomic, copy, readonly) NSString *emoticonCodePattern;

- (instancetype)initWithTypes:(MPMDataDetectorCheckResultType)checkingTypes error:(NSError * _Nullable *)error;

- (NSArray<MPMDataDetectorCheckResult *> *)matchesInString:(NSString *)string options:(NSMatchingOptions)options;
- (void)asyncMatchesInString:(NSString *)string options:(NSMatchingOptions)options completion:(void (^)(NSArray<MPMDataDetectorCheckResult *> *))completion;

@end

NS_ASSUME_NONNULL_END
