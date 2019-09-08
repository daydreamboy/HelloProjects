//
//  NSObject+WCObjCRuntime.h
//  WCObjCRuntime
//
//  Created by wesley chen on 3/11/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WCRTProtocol;
@class WCRTIvar;
@class WCRTProperty;
@class WCRTMethod;
@class WCRTUnregisteredClass;

@interface NSObject (WCObjCRuntime)

// includes the receiver
+ (NSArray *)rt_subclasses;

+ (WCRTUnregisteredClass *)rt_createUnregisteredSubclassNamed: (NSString *)name;
+ (Class)rt_createSubclassNamed: (NSString *)name;
+ (void)rt_destroyClass;

+ (BOOL)rt_isMetaClass;
+ (Class)rt_setSuperclass: (Class)newSuperclass;
+ (size_t)rt_instanceSize;

+ (NSArray *)rt_protocols;

+ (NSArray *)rt_methods;
+ (WCRTMethod *)rt_methodForSelector: (SEL)sel;

+ (void)rt_addMethod: (WCRTMethod *)method;

+ (NSArray *)rt_ivars;
+ (WCRTIvar *)rt_ivarForName: (NSString *)name;

+ (NSArray *)rt_properties;
+ (WCRTProperty *)rt_propertyForName: (NSString *)name;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
+ (BOOL)rt_addProperty: (WCRTProperty *)property;
#endif

// Apple likes to fiddle with -class to hide their dynamic subclasses
// e.g. KVO subclasses, so [obj class] can lie to you
// rt_class is a direct call to object_getClass (which in turn
// directly hits up the isa) so it will always tell the truth
- (Class)rt_class;
- (Class)rt_setClass: (Class)newClass;

@end
