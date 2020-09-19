//
//  WCArrayTool.h
//  HelloNSLocale
//
//  Created by wesley_chen on 2020/9/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCArrayTool : NSObject

@end

@interface WCArrayTool ()

+ (nullable NSArray<NSArray<NSString *> *> *)sortedGroupsByPrefixCharWithStrings:(NSArray<NSString *> *)strings;
+ (nullable NSArray<NSArray<NSString *> *> *)sortedGroupsWithStrings:(NSArray<NSString *> *)strings groupKeyBlock:(NSString * (^)(NSString *string))groupKeyBlock;

@end

NS_ASSUME_NONNULL_END
