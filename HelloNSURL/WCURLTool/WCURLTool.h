//
//  WCURLTool.h
//  HelloNSURL
//
//  Created by wesley_chen on 2018/7/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

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

/**
 Get URL with new query key values

 @param URL the original URL
 @param queryKeyValues the query key values to append. The key value pairs' order is uncertained,
        but always after the original URL's query string.
 @return the modified URL
 */
+ (nullable NSURL *)URLWithURL:(NSURL *)URL toAppendQueryKeyValues:(nullable NSDictionary<NSString *, NSString *> *)queryKeyValues;

+ (nullable NSURL *)URLWithURL:(NSURL *)URL toAppendQueryKey:(NSString *)key value:(NSString *)value;

@end

NS_ASSUME_NONNULL_END
