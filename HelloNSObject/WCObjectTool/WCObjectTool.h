//
//  WCObjectTool.h
//  HelloNSObject
//
//  Created by wesley_chen on 2019/3/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The pair structure of the selector and block
 
 @discussion the block use id (^)(id, ...) as signature without _cmd,
 because the selector of the method is not available to block from document of
 the imp_implementationWithBlock
 */
typedef struct selBlockPair {
    SEL sel;
    id (^__unsafe_unretained block)(id, ...);
} selBlockPair;

#define selBlockPair_nil    ((struct selBlockPair) { 0, 0 })
#define selBlockPair_list   (struct selBlockPair [])
#define selBlockPair_block   (id (^)(id, ...))

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

/**
 Get all class names which registered in the runtime
 
 @return the all class names
 */
+ (NSArray<NSString *> *)allClasses;

/**
 Get all subclass names which inherit from the parent class
 
 @param parentClass the parent class
 @return the all subclass names
 */
+ (NSArray<NSString *> *)subclassesOfClass:(Class)parentClass;

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
 Get all ivars description of the class

 @param clz the class
 @return the ivar string array.
 @discussion the property string format is `type _ivar`, e.g. NSString* _name
 */
+ (nullable NSArray<NSString *> *)ivarsDescriptionWithClass:(Class)clz;

/**
 Get all ivars description of the class
 
 @param instance the object
 @return the ivar string array.
 @discussion see +[WCObjectTool ivarsDescriptionWithClass:] for detail.
 */
+ (nullable NSArray<NSString *> *)ivarsDescriptionWithInstance:(id)instance;

/**
 Get object value of ivar
 
 @param instance the object
 @param ivarName the ivar name
 
 @return the pointer of the value (object type) of ivar
 @note This method only get the value of object ivar, not for primitive ivar
 */
+ (nullable id)objectIvarWithInstance:(id)instance ivarName:(NSString *)ivarName;

/**
 Get primitive value of ivar
 
 @param instance the object
 @param ivarName the ivar name
 @param objCType the type string by \@encode(type)
 
 @return the NSValue which encapsulate the primitive value. For example, use CGSizeValue to get CGSize struct,
 and use getValue: or getValue:size: to get double/int/.. and so on
 
 @discussion Use primitiveValueFromNSValue macro extract primitive value from NSValue object
 */
+ (nullable NSValue *)primitiveValueIvarWithInstance:(id)instance ivarName:(NSString *)ivarName objCType:(const char *)objCType;

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


#pragma mark > Create Class

/**
 Create a subclass in the runtime
 
 @param className the subclass name, if nil use a random class name instead
 @param baseClassName the base class, if nil use NSObject instead
 @param protocolNames the protocol name array.
 @param selBlockPairs the pair of the selector and block.
 @return the Class if create successfully
 @discussion The pair list's format, for example as following
    selBlockPair_list {
        @selector(description),
        selBlockPair_block ^id (id sender) {
            return @"This is a MyCustomString string";
        },
        NSSelectorFromString(@"hello:"),
        selBlockPair_block ^id (id sender, NSString *name) {
            NSLog(@"hello %@!", name);
            return nil;
        },
        selBlockPair_nil
    }
 1. The first value is the SEL
 2. The second value is the block with signature `id (^)(id, ...)`
    - return nil if no return value
    - the first paramter is always the sender object
    - no self/_cmd parameter in the block
 3. Use selBlockPair_block to cast the block
 4. Use selBlockPair_nil as pair list terminator
 5. Use selBlockPair_list to cast the pair list
 */
+ (nullable Class)createSubclassWithClassName:(nullable NSString *)className baseClassName:(nullable NSString *)baseClassName protocolNames:(NSArray<NSString *> * _Nullable)protocolNames selBlockPairs:(selBlockPair * _Nullable)selBlockPairs;

@end

NS_ASSUME_NONNULL_END
