//
//  WCMacroTool.h
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

// >= `11.0` Base SDK
#if defined(__IPHONE_11_0)
#define IOS11_SDK_OR_LATER_AVAILABLE 1
#else
#define IOS11_SDK_OR_LATER_AVAILABLE 0
#endif

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

#define weakify(object) \
__weak __typeof__(object) object##_weak_ = object;

#define strongify(object) \
__strong __typeof__(object) object = object##_weak_;

#define strongifyWithReturn(object, ...) \
__strong __typeof__(object) object = object##_weak_; \
if (!object) { \
    __VA_ARGS__; \
}

#define SHOW_ALERT(title, msg, cancel, dismissCompletion) \
\
do { \
    if ([UIAlertController class]) { \
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:(title) message:(msg) preferredStyle:UIAlertControllerStyleAlert]; \
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:(cancel) style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) { \
            dismissCompletion; \
        }]; \
        [alert addAction:cancelAction]; \
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:nil]; \
    } \
} while (0)

#ifndef ARR_SAFE_GET
#define ARR_SAFE_GET(array, index)                      \
    ({                                                      \
        id __value = nil;                                   \
        if ([array isKindOfClass:[NSArray class]] && 0 <= index && index < [(NSArray *)array count]) { \
            __value = [(NSArray *)array objectAtIndex:index];          \
        }                                                   \
        __value;                                            \
    })
#endif /* ARR_SAFE_GET */

#endif /* WCMacroTool_h */
