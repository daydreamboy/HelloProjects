//
//  WCMacroTool.h
//  HelloNSAttributedString
//
//  Created by wesley_chen on 2020/11/8.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

#define weakify(object) \
__weak __typeof__(object) object##_weak_ = object;

#define strongify(object) \
__strong __typeof__(object) object = object##_weak_;

#define strongifyWithReturn(object, ...) \
__strong __typeof__(object) object = object##_weak_; \
if (!object) { \
   __VA_ARGS__; \
}

// Is a string and not empty
#define STR_IF_NOT_EMPTY(str)    ([(str) isKindOfClass:[NSString class]] && [(NSString *)(str) length])

#define BLOCK_SAFE_RUN(block, ...) block ? block(__VA_ARGS__) : nil

#endif /* WCMacroTool_h */
