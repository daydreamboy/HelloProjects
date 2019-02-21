//
//  WCDataDetector.h
//  HelloNSDataDetector
//
//  Created by wesley_chen on 2018/7/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A data detector wrappping NSDataDetector
 */
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

#pragma mark > Porperties for NSTextCheckingTypeLink

/**
 The allowed link scheme to detect when check type is NSTextCheckingTypeLink.
 
 Default is empty and allow all link schemes.
 
 @discussion The link scheme not in this array will be ignored.
 @note `forceDetectHttpScheme` property will work before this property works.
 */
@property (nonatomic, strong) NSArray<NSString *> *allowedLinkSchemes;

/**
 Should force detect `http/https` schemes when check type is NSTextCheckingTypeLink.
 
 Default is NO.
 
 @discussion The NSDataDetector detects link any scheme starts with `://`, not only for `http://` or `https://`.
 So use this property to force detect `http/https` schemes, for example, @"fakehttps://www.google.com/中文" will
 take `https://www.google.com/` as link, not the `fakehttps://www.google.com/中文`
 */
@property (nonatomic, assign) BOOL forceDetectHttpScheme;

/**
 Enable strict link url which only allow URL-allowed characters in the url.
 For example, `https://www.google.com/中文` will detect as `https://www.google.com/`
 
 Default is YES
 */
@property (nonatomic, assign) BOOL enableStrictLinkUrl;

#pragma mark -

/**
 Get an instance

 @param checkingTypes the check types
 @param error the NSError if initialized failed
 @return the instance of WCDataDetector
 */
- (instancetype)initWithTypes:(NSTextCheckingTypes)checkingTypes error:(NSError * _Nullable *)error;

/**
 Get matches from the string

 @param string the string to check
 @param options the matching option
 @return the array of check result
 */
- (nullable NSArray<NSTextCheckingResult *> *)matchesInString:(NSString *)string options:(NSMatchingOptions)options;

/**
 Asynchronously get matches from the string

 @param string the string to check
 @param options the matching option
 @param completion the callback when get the array of check result
 */
- (void)asyncMatchesInString:(NSString *)string options:(NSMatchingOptions)options completion:(void (^)(NSArray<NSTextCheckingResult *> * _Nullable))completion;

@end

NS_ASSUME_NONNULL_END
