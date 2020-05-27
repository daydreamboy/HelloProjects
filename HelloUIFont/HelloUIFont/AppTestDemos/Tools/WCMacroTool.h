//
//  WCMacroTool.h
//  HelloUIFont
//
//  Created by wesley_chen on 2020/5/27.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

#ifndef NSARRAY_SAFE_GET
#define NSARRAY_SAFE_GET(array, index)                      \
    ({                                                      \
        id value = nil;                                     \
        if (array && 0 <= index && index < [array count]) { \
            value = [array objectAtIndex:index];            \
        }                                                   \
        value;                                              \
    })

#endif /* NSARRAY_SAFE_GET */

#define FrameSetSize(frame, newWidth, newHeight) ({ \
CGRect __internal_frame = (frame); \
if (!isnan((newWidth))) { \
    __internal_frame.size.width = (newWidth); \
} \
if (!isnan((newHeight))) { \
    __internal_frame.size.height = (newHeight); \
} \
__internal_frame; \
})

#define FrameSetOrigin(frame, newX, newY) ({ \
CGRect __internal_frame = (frame); \
if (!isnan((newX))) { \
    __internal_frame.origin.x = (newX); \
} \
if (!isnan((newY))) { \
    __internal_frame.origin.y = (newY); \
} \
__internal_frame; \
})

#endif /* WCMacroTool_h */
