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

#pragma mark > Dump

/**
 Dump an object with printf

 @param object the NSObject
 */
+ (void)dumpWithObject:(NSObject *)object;

/**
 Get the object's dumped string

 @param object the NSObject
 @return the dumped string
 */
+ (nullable NSString *)dumpedStringWithObject:(NSObject *)object;

#pragma mark - Runtime

#pragma mark > Classes

+ (NSArray<NSString *> *)allClasses;

#pragma mark > Properties

/**
 Get all properties of the class

 @param clz the class
 @return the property string array.
 @discussion the property string format is `@property (modifier1, modifier2, ...) type property_name`, e.g. @property (atomic, copy, readonly) NSString* description
 */
+ (nullable NSArray<NSString *> *)propertiesWithClass:(Class)clz;

/**
 Get all properties of the instance

 @param instance the object
 @return the property string array.
 @discussion see +[WCObjectTool propertiesWithClass:] for detail.
 */
+ (nullable NSArray<NSString *> *)propertiesWithInstance:(id)instance;

@end

NS_ASSUME_NONNULL_END
