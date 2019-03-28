//
//  WCObjectTool.h
//  HelloNSObject
//
//  Created by wesley_chen on 2019/3/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCObjectTool : NSObject

#pragma mark - Inspection

+ (void)dumpWithObject:(NSObject *)object;
+ (nullable NSString *)dumpedStringWithObject:(NSObject *)object;

@end

NS_ASSUME_NONNULL_END
