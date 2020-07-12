//
//  WCMacroTool.h
//  HelloUIPasteboard
//
//  Created by wesley_chen on 2020/7/11.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

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

#ifndef UNSPECIFIED
#define UNSPECIFIED 0
#endif

#define weakify(object) \
__weak __typeof__(object) object##_weak_ = object;

#define strongify(object) \
__strong __typeof__(object) object = object##_weak_;

#define strongifyWithReturn(object, ...) \
__strong __typeof__(object) object = object##_weak_; \
if (!object) { \
    __VA_ARGS__; \
}

#define STR_CATENATE(str1, str2) ([NSString stringWithFormat:@"%@%@", str1, str2])

#endif /* WCMacroTool_h */
