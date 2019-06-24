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

#pragma mark > Class

+ (NSArray<NSString *> *)allClasses;

#pragma mark > Property

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

#pragma mark > Ivar

/**
 Get all ivars of the class

 @param clz the class
 @return the ivar string array.
 @discussion the property string format is `type _ivar`, e.g. NSString* _name
 */
+ (nullable NSArray<NSString *> *)ivarsWithClass:(Class)clz;

/**
 Get all ivars of the class
 
 @param instance the object
 @return the ivar string array.
 @discussion see +[WCObjectTool ivarsWithClass:] for detail.
 */
+ (nullable NSArray<NSString *> *)ivarsWithInstance:(id)instance;

#pragma mark > Class Method

+ (nullable NSArray<NSString *> *)classMethodsWithClass:(Class)clz;
+ (nullable NSArray<NSString *> *)classMethodsWithInstance:(id)instance;

#pragma mark > Instance Method

+ (nullable NSArray<NSString *> *)instanceMethodsWithClass:(Class)clz;
+ (nullable NSArray<NSString *> *)instanceMethodsWithInstance:(id)instance;

#pragma mark > Protocol

+ (nullable NSArray<NSString *> *)protocolsWithClass:(Class)clz;
+ (nullable NSArray<NSString *> *)protocolsWithInstance:(id)instance;

+ (nullable NSDictionary<NSString *, NSArray *> *)descriptionForProtocolName:(NSString *)protocolName;

/**
 Get methods signatures declared in protocol

 @param protocol the protocol to inspect
 @return the map of method signatures in protocol. The keys are @required, @optional, @properties
 */
+ (nullable NSDictionary<NSString *, NSArray *> *)descriptionForProtocol:(Protocol *)protocol;

#pragma mark > Class Hierarchy

+ (nullable NSArray<NSString *> *)classHierarchyWithClass:(Class)clz;
+ (nullable NSArray<NSString *> *)classHierarchyWithInstance:(id)instance;

+ (nullable NSString *)printClassHierarchyWithClass:(Class)clz;
+ (nullable NSString *)printClassHierarchyWithInstance:(id)instance;

#pragma mark > Check Method Override

/**
 Check object if overrides the method

 @param object the object to check
 @param selector the selector
 @return YES if overrides, otherwise NO
 @discussion This method internally calls the +[WCObjectTool checkIfSubclass:overridesSelector:]
 */
+ (BOOL)checkIfObject:(id)object overridesSelector:(SEL)selector;

/**
 Check object if overrides the method

 @param subclass the subclass to check
 @param selector the selector
 @return YES if overrides, otherwise NO
 @see https://stackoverflow.com/a/28737576
 */
+ (BOOL)checkIfSubclass:(Class)subclass overridesSelector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
