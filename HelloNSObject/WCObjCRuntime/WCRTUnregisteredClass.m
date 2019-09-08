//
//  WCRTUnregisteredClass.m
//  WCObjCRuntime
//
//  Created by wesley chen on 3/11/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "WCRTUnregisteredClass.h"

#import "WCRTProtocol.h"
#import "WCRTIvar.h"
#import "WCRTMethod.h"
#import "WCRTProperty.h"


@implementation WCRTUnregisteredClass

+ (id)unregisteredClassWithName: (NSString *)name withSuperclass: (Class)superclass
{
    return [[[self alloc] initWithName: name withSuperclass: superclass] autorelease];
}

+ (id)unregisteredClassWithName: (NSString *)name
{
    return [self unregisteredClassWithName: name withSuperclass: Nil];
}

- (id)initWithName: (NSString *)name withSuperclass: (Class)superclass
{
    if((self = [self init]))
    {
        _class = objc_allocateClassPair(superclass, [name UTF8String], 0);
        if(_class == Nil)
        {
            [self release];
            return nil;
        }
    }
    return self;
}

- (id)initWithName: (NSString *)name
{
    return [self initWithName: name withSuperclass: Nil];
}

- (void)addProtocol: (WCRTProtocol *)protocol
{
    class_addProtocol(_class, [protocol objCProtocol]);
}

- (void)addIvar: (WCRTIvar *)ivar
{
    const char *typeStr = [[ivar typeEncoding] UTF8String];
    NSUInteger size, alignment;
    NSGetSizeAndAlignment(typeStr, &size, &alignment);
    class_addIvar(_class, [[ivar name] UTF8String], size, log2(alignment), typeStr);
}

- (void)addMethod: (WCRTMethod *)method
{
    class_addMethod(_class, [method selector], [method implementation], [[method signature] UTF8String]);
}

#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
- (void)addProperty: (WCRTProperty *)property
{
    [property addToClass:_class];
}
#endif

- (Class)registerClass
{
    objc_registerClassPair(_class);
    return _class;
}

@end
