//
//  WCJSONTool.h
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (WCJSONTool)
#pragma mark - JSON String
/// Get a json string of NSArray with plain style
- (NSString *)jsonString NS_AVAILABLE_IOS(5_0);
/// Get a json string of NSArray with readable style
- (NSString *)jsonStringWithReadability NS_AVAILABLE_IOS(5_0);

@end

@interface NSDictionary (WCJSONTool)
#pragma mark - JSON string
- (NSString *)jsonString NS_AVAILABLE_IOS(5_0);
- (NSString *)jsonStringWithReadability NS_AVAILABLE_IOS(5_0);
@end

@interface WCJSONTool : NSObject

/**
 Convert object to JSON string

 @param object the object which can match JSON element, e.g. NSArray/NSDictionary/NSNumber/NSString/NSNull
 @param options the options, kNilOptions for compact string.
 @return the JSON formatted string
 
 @see https://www.json.org/
 @see http://stackoverflow.com/questions/6368867/generate-json-string-from-nsdictionary
 */
+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options NS_AVAILABLE_IOS(5_0);

#pragma mark - Convert JSON String/Data to NSDictionary

+ (NSMutableDictionary *)mutableDictionaryWithJSONString:(NSString *)jsonString;
+ (NSMutableDictionary *)mutableDictionaryWithJSONData:(NSData *)jsonData;

+ (NSMutableArray *)mutableArrayWithJSONString:(NSString *)jsonString;
+ (NSMutableArray *)mutableArrayWithJSONData:(NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
