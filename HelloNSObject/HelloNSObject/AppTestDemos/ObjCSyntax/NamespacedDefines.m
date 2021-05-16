//
//  NamespacedDefines.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/4/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "NamespacedDefines.h"

// Note: C99 support field name in struct, e.g. `.didAddObject`, `.keys`
const struct MANotifyingArrayNotifications MANotifyingArrayNotifications = {
    .didAddObject = @"didAddObject",
    .didChangeObject = @"didChangeObject",
    .didRemoveObject = @"didRemoveObject",
    .keys = {
        .indexChanged = @"indexChanged",
        .objectChanged = @"objectChanged"
    }
};

static CGPoint topLeft(CGRect r)
{
    return r.origin;
}

static CGPoint topRight(CGRect r)
{
    return CGPointMake(CGRectGetMaxX(r), CGRectGetMinY(r));
}

static CGPoint bottomLeft(CGRect r)
{
    return CGPointMake(CGRectGetMinX(r), CGRectGetMaxY(r));
}

static CGPoint bottomRight(CGRect r)
{
    return CGPointMake(CGRectGetMaxX(r), CGRectGetMaxY(r));
}

const struct MARectUtils MARectUtils = {
    .topLeft = topLeft,
    .topRight = topRight,
    .bottomLeft = bottomLeft,
    .bottomRight = bottomRight
};

const struct WCNotifyingArrayNotifications WCNotifyingArrayNotifications = {
    .didAddObject = @"didAddObject",
    .didChangeObject = @"didChangeObject",
    .didRemoveObject = @"didRemoveObject",
    .keys = {
        .indexChanged = @"indexChanged",
        .objectChanged = @"objectChanged"
    }
};

const struct WCRectTool WCRectTool = {
    .topLeft = topLeft,
    .topRight = topRight,
    .bottomLeft = bottomLeft,
    .bottomRight = bottomRight
};
