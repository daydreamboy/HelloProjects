//
//  WCRTProperty.h
//  WCObjCRuntime
//
//  Created by wesley chen on 3/11/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>


typedef enum
{
    WCRTPropertySetterSemanticsAssign,
    WCRTPropertySetterSemanticsRetain,
    WCRTPropertySetterSemanticsCopy
}
WCRTPropertySetterSemantics;

@interface WCRTProperty : NSObject
{
}

+ (id)propertyWithObjCProperty: (objc_property_t)property;
+ (id)propertyWithName: (NSString *)name attributes:(NSDictionary *)attributes;

- (id)initWithObjCProperty: (objc_property_t)property;
- (id)initWithName: (NSString *)name attributes:(NSDictionary *)attributes;

- (NSDictionary *)attributes;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
- (BOOL)addToClass:(Class)classToAddTo;
#endif

- (NSString *)attributeEncodings;
- (BOOL)isReadOnly;
- (WCRTPropertySetterSemantics)setterSemantics;
- (BOOL)isNonAtomic;
- (BOOL)isDynamic;
- (BOOL)isWeakReference;
- (BOOL)isEligibleForGarbageCollection;
- (SEL)customGetter;
- (SEL)customSetter;
- (NSString *)name;
- (NSString *)typeEncoding;
- (NSString *)oldTypeEncoding;
- (NSString *)ivarName;

@end

extern NSString * const WCRTPropertyTypeEncodingAttribute;
extern NSString * const WCRTPropertyBackingIVarNameAttribute;

extern NSString * const WCRTPropertyCopyAttribute;
extern NSString * const WCRTPropertyRetainAttribute;
extern NSString * const WCRTPropertyCustomGetterAttribute;
extern NSString * const WCRTPropertyCustomSetterAttribute;
extern NSString * const WCRTPropertyDynamicAttribute;
extern NSString * const WCRTPropertyEligibleForGarbageCollectionAttribute;
extern NSString * const WCRTPropertyNonAtomicAttribute;
extern NSString * const WCRTPropertyOldTypeEncodingAttribute;
extern NSString * const WCRTPropertyReadOnlyAttribute;
extern NSString * const WCRTPropertyWeakReferenceAttribute;
