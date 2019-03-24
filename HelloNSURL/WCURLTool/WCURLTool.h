//
//  WCURLTool.h
//  HelloNSURL
//
//  Created by wesley_chen on 2018/7/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Key Value Pair Suite

/**
 Make a pair of key value

 @param key the key object
 @param value the value object
 @return the a pair of key value
 @see https://stackoverflow.com/a/33525373
 */
#define KeyValuePair(key, value)    @[((key) ?: [NSNull null]), ((value) ?: [NSNull null])]
/**
 The type of key value pair
 */
typedef NSArray * KeyValuePairType;
/**
 Check object if a key value pair

 @param object the object
 @return YES if the object is a key value pair, or return NO if not
 */
#define KeyValuePairValidate(object)  ([(object) isKindOfClass:[NSArray class]] && [(object) count] == 2)
/**
 Get the key object of pair

 @param pair the pair object
 @return the key object
 */
#define KeyOfPair(pair)             (KeyValuePairValidate(pair) ? ([pair firstObject] == [NSNull null] ? nil : [pair firstObject]) : nil)
/**
 Get the value object of pair

 @param pair the pair object
 @return the value object
 */
#define ValueOfPair(pair)           (KeyValuePairValidate(pair) ? ([pair lastObject] == [NSNull null] ? nil : [pair lastObject]) : nil)

NS_ASSUME_NONNULL_BEGIN

NS_AVAILABLE_IOS(8_0)
/// The WCURLQueryItem for storing key-value pairs which is key1=value1&...&keyN=valueN
@interface WCURLQueryItem : NSObject
/// this field missing, e.g. (missing)=value, will get @""
@property (nonatomic, copy, nullable) NSString *name;
/// this field missing, e.g. key=(missing), will get @""
@property (nonatomic, copy, nullable) NSString *value;
/// the query string which not include `?`
@property (nonatomic, copy) NSString *queryString;

@property (nonatomic, assign) NSRange rangeOfName;
@property (nonatomic, assign) NSRange rangeOfValue;

+ (instancetype)queryItemWithName:(NSString *)name value:(NSString *)value;
@end

NS_AVAILABLE_IOS(8_0)
@interface WCURLComponents : NSObject
/**
 The original url string
 */
@property (nonatomic, copy, nullable) NSString *string;
@property (nonatomic, copy, nullable) NSString *scheme;
@property (nonatomic, copy, nullable) NSString *user;
@property (nonatomic, copy, nullable) NSString *password;
@property (nonatomic, copy, nullable) NSString *host;
@property (nonatomic, strong, nullable) NSNumber *port;
@property (nonatomic, copy, nullable) NSString *path;
@property (nonatomic, copy, nullable) NSString *pathExtension;
@property (nonatomic, copy, nullable) NSString *parameterString;
@property (nonatomic, copy, nullable) NSString *query;
@property (nonatomic, copy, nullable) NSString *fragment;
/**
 The parameters in query string
 */
@property (nonatomic, strong, nullable) NSArray<WCURLQueryItem *> *queryItems;
/**
 The parameters in query string
 
 @warning the keys maybe duplicated, and which one is overwrite not determined. Use `queryItems` instead for more safe
 */
@property (nonatomic, strong, nullable) NSMutableDictionary<NSString *, NSString *> *queryKeyValues;

@property (nonatomic, assign) NSRange rangeOfScheme;
@property (nonatomic, assign) NSRange rangeOfUser;
@property (nonatomic, assign) NSRange rangeOfPassword;
@property (nonatomic, assign) NSRange rangeOfHost;
@property (nonatomic, assign) NSRange rangeOfPort;
@property (nonatomic, assign) NSRange rangeOfPath;
@property (nonatomic, assign) NSRange rangeOfPathExtension;
@property (nonatomic, assign) NSRange rangeOfParameterString;
@property (nonatomic, assign) NSRange rangeOfQuery;
@property (nonatomic, assign) NSRange rangeOfFragment;

@end

typedef NS_OPTIONS(NSUInteger, WCURLQueryKeyValueReplacementOption) {
    /*! Reorder key/values after replace */
    WCURLQueryKeyValueReplacementOptionReorder = 1 << 0,
    /*! Replace only key exists and not add to the URL when key not exists */
    WCURLQueryKeyValueReplacementOptionReplaceOnlyKeyExists = 1 << 1,
};

NS_AVAILABLE_IOS(8_0)
@interface WCURLTool : NSObject

@property (nonatomic, copy, readonly, class) NSString *patternOfURI;
@property (nonatomic, copy, readonly, class) NSString *patternOfAuthorityComponent;
@property (nonatomic, copy, readonly, class) NSString *patternOfPathComponent;
@property (nonatomic, copy, readonly, class) NSString *patternOfQueryItems;
@property (nonatomic, copy, readonly, class) NSString *patternOfPathExtension;

/**
 Get URL for local png image

 @param imageName the png name without extension and @2x or @3x
 @param resourceBundleName the resource bundle name. If nil, use main bundle
 @return the NSURL for the png image
 */
+ (nullable NSURL *)PNGImageURLWithImageName:(NSString *)imageName inResourceBundle:(NSString *)resourceBundleName;

/**
 Get a URL component which parsed with the url string

 @param urlString the url string which should match the url rule.
 @return the WCURLComponents object. Return nil if the urlString is invalid (e.g. nil, malformed)
 */
+ (nullable WCURLComponents *)URLComponentsWithUrlString:(NSString *)urlString;

#pragma mark - Get new URL

/**
 Get URL with new query key values

 @param URL the original URL
 @param queryKeyValues the query key values to append. The key value pairs' order is uncertained,
        but always after the original URL's query string.
 @return the modified URL
 */
+ (nullable NSURL *)URLWithURL:(NSURL *)URL toAppendQueryKeyValues:(nullable NSDictionary<NSString *, NSString *> *)queryKeyValues;

/**
 Get URL with a new query key value

 @param URL the original URL
 @param key the key
 @param value the value
 @return the modified URL
 */
+ (nullable NSURL *)URLWithURL:(NSURL *)URL toAppendQueryKey:(NSString *)key value:(NSString *)value;

/**
 Get URL with an array of query key values

 @param URL the original URL
 @param queryKeyValueArray the array of KeyValuePairType objects
 @return the modified URL
 */
+ (nullable NSURL *)URLWithURL:(NSURL *)URL toAppendQueryKeyValueArray:(nullable NSArray<KeyValuePairType> *)queryKeyValueArray;

/**
 Replace URL with query key values and scheme

 @param URL the original URL
 @param queryKeyValueArray the query key values to replace.
 - If key is not NSString, the query key value is ignored
 - If value is not NSString or [NSNull null], the query key value is ignored. If value is [NSNull null], to remove the key.
 @param scheme the new scheme. If nil or empty, not change the original scheme
 @param options the flags
 - Default (kNilOption).
   Keep the original order and the new key values (which the key not exists in the original URL) will add or append to the URL
 - WCURLQueryKeyValueReplacementOptionReorder
   Should be to reorder alphabetically, ordered by key firstly and then by value
 - WCURLQueryKeyValueReplacementOptionReplaceOnlyKeyExists
   Only when key exists to replace. If key not exists, the new key value not appends to the URL.
 @return the new URL after replacement
 */
+ (nullable NSURL *)URLWithURL:(NSURL *)URL replacedByQueryKeyValueArray:(nullable NSArray<KeyValuePairType> *)queryKeyValueArray scheme:(nullable NSString *)scheme options:(WCURLQueryKeyValueReplacementOption)options;

/**
 Get the base part of NSURL without query parameters

 @param URL the original URL
 @return the base URL, e.g. `http://www.abc.com/foo/bar.cgi?a=1&b=2` => `http://www.abc.com/foo/bar.cgi`
 @see http://stackoverflow.com/questions/4271916/url-minus-query-string-in-objective-c
 */
+ (nullable NSURL *)baseURLWithURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
