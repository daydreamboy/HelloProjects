//
//  WCObjectTool.h
//  HelloNSObject
//
//  Created by wesley_chen on 2019/3/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef IMP *IMPPtr;

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

/**
 Get the object's dumped JSON object

 @param object the NSObject
 @return the dumped JSON object
 */
+ (nullable id)dumpedJSONObjectWithObject:(id)object;

#pragma mark - Runtime Query

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

#pragma mark - Runtime Modify

#pragma mark > Swizzle Method

/**
 Exchange the IMP of the existing selector to another IMP of the selector

 @param class the Class to modify
 @param originalSelector the original selector which should exist, and usually compiled in code
 @param swizzledSelector the swizzled selector which usually created in runtime
 @param block the swizzled block which must match the signature of the `originalSelector`
 @return YES if the operate successfull. NO if any error occurred internally.
 @discussion This method will create new selector (`swizzledSelector`) and its IMP if the IMP not exists. And
 replace the swizzled selector's IMP if the swizzled selector already has the previous one.
 */
+ (BOOL)exchangeIMPWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector swizzledBlock:(id)block;

/**
 Replace or add the IMP of the original selector with block

 @param class the Class to modify
 @param originalSelector the original selector whose IMP exists or not exists
 @param block the swizzled block which mapping to the `originalSelector` and must match the signature of the `originalSelector`
 @param originalIMPPtr the original IMP. If the `originalSelector` not exists, the IMP is the swizzled block.
 If the `originalSelector` exists, the IMP is the old IMP.
 @return YES if the operate successfull. NO if any error occurred internally.
 */
+ (BOOL)replaceIMPWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledBlock:(id)block originalIMPPtr:(IMPPtr _Nullable)originalIMPPtr;

/**
 Exchange the IMP for two existing selectors

 @param class the Class to modify
 @param selector1 the selector1
 @param selector2 the selector2
 @return YES if the operate successfull. NO if any error occurred internally.
 */
+ (BOOL)exchangeIMPForClass:(Class)class selector1:(SEL)selector1 selector2:(SEL)selector2;

#pragma mark > Swizzle Assistant Method

/**
 Return a random selector name for given selector
 
 @param selector the original selector
 @return the modified selector which created with prefix
 */
+ (SEL)swizzledSelectorWithSelector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
