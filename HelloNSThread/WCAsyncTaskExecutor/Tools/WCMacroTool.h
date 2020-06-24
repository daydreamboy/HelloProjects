//
//  WCMacroTool.h
//  HelloNSThread
//
//  Created by wesley_chen on 2020/6/24.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

#pragma mark - Weak-Strong Dance

#define weakify(object) \
__weak __typeof__(object) object##_weak_ = object;


#define strongify(object) \
__strong __typeof__(object) object = object##_weak_;


#define strongifyWithReturn(object, ...) \
__strong __typeof__(object) object = object##_weak_; \
if (!object) { \
    __VA_ARGS__; \
}

#endif /* WCMacroTool_h */
