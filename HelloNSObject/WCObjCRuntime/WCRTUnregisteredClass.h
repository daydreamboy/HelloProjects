//
//  WCRTUnregisteredClass.h
//  WCObjCRuntime
//
//  Created by wesley chen on 3/11/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WCRTProtocol;
@class WCRTIvar;
@class WCRTMethod;
@class WCRTProperty;

@interface WCRTUnregisteredClass : NSObject
{
    Class _class;
}

+ (id)unregisteredClassWithName: (NSString *)name withSuperclass: (Class)superclass;
+ (id)unregisteredClassWithName: (NSString *)name;

- (id)initWithName: (NSString *)name withSuperclass: (Class)superclass;
- (id)initWithName: (NSString *)name;

- (void)addProtocol: (WCRTProtocol *)protocol;
- (void)addIvar: (WCRTIvar *)ivar;
- (void)addMethod: (WCRTMethod *)method;
#if __MAC_OS_X_VERSION_MIN_REQUIRED >= 1070
- (void)addProperty: (WCRTProperty *)property;
#endif

- (Class)registerClass;

@end
