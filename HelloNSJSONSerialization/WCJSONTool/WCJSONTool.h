//
//  WCJSONTool.h
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

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
/// Convert JSON object (NSArray/NSDictionary) to JSON string
+ (NSString *)jsonStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options;

#pragma mark - Convert JSON String/Data to NSDictionary
+ (NSMutableDictionary *)mutableDictionaryWithJSONString:(NSString *)jsonString;
+ (NSMutableDictionary *)mutableDictionaryWithJSONData:(NSData *)jsonData;

+ (NSMutableArray *)mutableArrayWithJSONString:(NSString *)jsonString;
+ (NSMutableArray *)mutableArrayWithJSONData:(NSData *)jsonData;

@end
