//
//  WCRTProtocol.h
//  WCObjCRuntime
//
//  Created by wesley chen on 3/11/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <objc/runtime.h>


@interface WCRTProtocol : NSObject
{
}

+ (NSArray *)allProtocols;

+ (id)protocolWithObjCProtocol: (Protocol *)protocol;
+ (id)protocolWithName: (NSString *)name;

- (id)initWithObjCProtocol: (Protocol *)protocol;
- (id)initWithName: (NSString *)name;

- (Protocol *)objCProtocol;
- (NSString *)name;
- (NSArray *)incorporatedProtocols;
- (NSArray *)methodsRequired: (BOOL)isRequiredMethod instance: (BOOL)isInstanceMethod;

@end
