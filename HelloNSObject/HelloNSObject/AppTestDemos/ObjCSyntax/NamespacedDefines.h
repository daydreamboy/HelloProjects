//
//  NamespacedDefines.h
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/4/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

// in the header
extern const struct MANotifyingArrayNotifications
{
    // @see https://stackoverflow.com/questions/14784973/fixing-arc-error-when-using-objective-c-object-in-struct
    __unsafe_unretained NSString *didAddObject;
    __unsafe_unretained NSString *didChangeObject;
    __unsafe_unretained NSString *didRemoveObject;
    const struct keys
    {
        __unsafe_unretained NSString *indexChanged;
        __unsafe_unretained NSString *objectChanged;
    } keys;
} MANotifyingArrayNotifications;

extern const struct MARectUtils
{
    CGPoint (*topLeft)(CGRect r);
    CGPoint (*topRight)(CGRect r);
    CGPoint (*bottomLeft)(CGRect r);
    CGPoint (*bottomRight)(CGRect r);
} MARectUtils;

// macro to namespace

#define NAMESPACE_BEGIN(namespace)  extern const struct namespace {
#define NAMESPACE_END(namespace)    } namespace;

#define NAMESPACE_NESTED_BEGIN(namespace) const struct {
#define NAMESPACE_NESTED_END(namespace) } namespace;

#define NAMESPACE_OBJC_TYPE __unsafe_unretained

// --- namespace `WCRectTool`

NAMESPACE_BEGIN(WCRectTool)
CGPoint (*topLeft)(CGRect r);
CGPoint (*topRight)(CGRect r);
CGPoint (*bottomLeft)(CGRect r);
CGPoint (*bottomRight)(CGRect r);
NAMESPACE_END(WCRectTool)

// --- namespace `WCNotifyingArrayNotifications`

NAMESPACE_BEGIN(WCNotifyingArrayNotifications)


NAMESPACE_OBJC_TYPE NSString *didAddObject;
NAMESPACE_OBJC_TYPE NSString *didChangeObject;
NAMESPACE_OBJC_TYPE NSString *didRemoveObject;

// --- nested namespace `keys`
NAMESPACE_NESTED_BEGIN(keys)
NAMESPACE_OBJC_TYPE NSString *indexChanged;
NAMESPACE_OBJC_TYPE NSString *objectChanged;
NAMESPACE_NESTED_END(keys)


NAMESPACE_END(WCNotifyingArrayNotifications)


