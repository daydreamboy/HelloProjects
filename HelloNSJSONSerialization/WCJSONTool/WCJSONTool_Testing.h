//
//  WCJSONTool+Testing.h
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 2019/1/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCJSONTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCJSONTool ()

/**
 Get Objective-C literal string from JSON object

 @param JSONObject the JSON object
 @param indentLevel the indent level which starts with 0
 @param startIndentLength the length of indent space for starting
 @param indentLength the length of indent space at every level
 @param ordered If YES, the dictionary keys are ordered, or not if NO.
 @param isRootContainer If the JSONObject is NSArray/NSDictionary, set isRootContainer to YES. Otherwise, set it to NO.
 @return the Objective-C literal string
 @discussion This method will keep boolean NSNumber as @YES/@NO, and numeric NSNumber as @(N).
             Other type values are kept as Objective-C literal constant value.
 */
+ (nullable NSString *)literalStringWithJSONObject:(id)JSONObject indentLevel:(NSUInteger)indentLevel startIndentLength:(NSUInteger)startIndentLength indentLength:(NSUInteger)indentLength ordered:(BOOL)ordered isRootContainer:(BOOL)isRootContainer;

@end

NS_ASSUME_NONNULL_END
