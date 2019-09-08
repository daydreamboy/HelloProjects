//
//  WCRTProtocol.m
//  WCObjCRuntime
//
//  Created by wesley chen on 3/11/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "WCRTProtocol.h"
#import "WCRTMethod.h"


@interface _RTObjCProtocol : WCRTProtocol
{
    Protocol *_protocol;
}
@end

@implementation _RTObjCProtocol

- (id)initWithObjCProtocol: (Protocol *)protocol
{
    if((self = [self init]))
    {
        _protocol = protocol;
    }
    return self;
}

- (Protocol *)objCProtocol
{
    return _protocol;
}

@end

@implementation WCRTProtocol

+ (NSArray *)allProtocols
{
    unsigned int count;
    Protocol **protocols = objc_copyProtocolList(&count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [[[self alloc] initWithObjCProtocol: protocols[i]] autorelease]];
    
    free(protocols);
    return array;
}

+ (id)protocolWithObjCProtocol: (Protocol *)protocol
{
    return [[[self alloc] initWithObjCProtocol: protocol] autorelease];
}

+ (id)protocolWithName: (NSString *)name
{
    return [[[self alloc] initWithName: name] autorelease];
}

- (id)initWithObjCProtocol: (Protocol *)protocol
{
    [self release];
    return [[_RTObjCProtocol alloc] initWithObjCProtocol: protocol];
}

- (id)initWithName: (NSString *)name
{
    return [self initWithObjCProtocol:objc_getProtocol([name cStringUsingEncoding:[NSString defaultCStringEncoding]])];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@ %p: %@>", [self class], self, [self name]];
}

- (BOOL)isEqual: (id)other
{
    return [other isKindOfClass: [WCRTProtocol class]] &&
           protocol_isEqual([self objCProtocol], [other objCProtocol]);
}

- (NSUInteger)hash
{
    return [[self objCProtocol] hash];
}

- (Protocol *)objCProtocol
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (NSString *)name
{
    return [NSString stringWithUTF8String: protocol_getName([self objCProtocol])];
}

- (NSArray *)incorporatedProtocols
{
    unsigned int count;
    Protocol **protocols = protocol_copyProtocolList([self objCProtocol], &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
        [array addObject: [WCRTProtocol protocolWithObjCProtocol: protocols[i]]];
    
    free(protocols);
    return array;
}

- (NSArray *)methodsRequired: (BOOL)isRequiredMethod instance: (BOOL)isInstanceMethod
{
    unsigned int count;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList([self objCProtocol], isRequiredMethod, isInstanceMethod, &count);
    
    NSMutableArray *array = [NSMutableArray array];
    for(unsigned i = 0; i < count; i++)
    {
        NSString *signature = [NSString stringWithCString: methods[i].types encoding: [NSString defaultCStringEncoding]];
        [array addObject: [WCRTMethod methodWithSelector: methods[i].name implementation: NULL signature: signature]];
    }
    
    free(methods);
    return array;
}

@end
