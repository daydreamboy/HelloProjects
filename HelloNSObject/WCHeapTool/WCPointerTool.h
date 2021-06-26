//
//  WCPointerTool.h
//  HelloNSObject
//
//  Created by wesley_chen on 2021/6/21.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef __cplusplus
extern "C" {
#endif

// The macros below are copied straight from
// objc-internal.h, objc-private.h, objc-object.h, and objc-config.h with
// as few modifications as possible. Changes are noted in boxed comments.
// https://opensource.apple.com/source/objc4/objc4-723/
// https://opensource.apple.com/source/objc4/objc4-723/runtime/objc-internal.h.auto.html
// https://opensource.apple.com/source/objc4/objc4-723/runtime/objc-object.h.auto.html

/////////////////////
// objc-internal.h //
/////////////////////

#if __LP64__
#define OBJC_HAVE_TAGGED_POINTERS 1
#endif

#if OBJC_HAVE_TAGGED_POINTERS

#if TARGET_OS_OSX && __x86_64__
// 64-bit Mac - tag bit is LSB
#   define OBJC_MSB_TAGGED_POINTERS 0
#else
// Everything else - tag bit is MSB
#   define OBJC_MSB_TAGGED_POINTERS 1
#endif

#if OBJC_MSB_TAGGED_POINTERS
#   define _OBJC_TAG_MASK (1UL<<63)
#   define _OBJC_TAG_EXT_MASK (0xfUL<<60)
#else
#   define _OBJC_TAG_MASK 1UL
#   define _OBJC_TAG_EXT_MASK 0xfUL
#endif

#endif // OBJC_HAVE_TAGGED_POINTERS

//////////////////////////////////////
// originally _objc_isTaggedPointer //
//////////////////////////////////////
NS_INLINE BOOL wc_isTaggedPointer(const void *ptr)  {
#if OBJC_HAVE_TAGGED_POINTERS
    return ((uintptr_t)ptr & _OBJC_TAG_MASK) == _OBJC_TAG_MASK;
#else
    return NO;
#endif
}

#define WCPointerIsTaggedPointer(obj) wc_isTaggedPointer((__bridge void *)obj)

BOOL WCPointerIsReadable(const void * ptr);

/// @brief Assumes memory is valid and readable.
/// @discussion objc-internal.h, objc-private.h, and objc-config.h
/// https://blog.timac.org/2016/1124-testing-if-an-arbitrary-pointer-is-a-valid-objective-c-object/
/// https://llvm.org/svn/llvm-project/lldb/trunk/examples/summaries/cocoa/objc_runtime.py
/// https://blog.timac.org/2016/1124-testing-if-an-arbitrary-pointer-is-a-valid-objective-c-object/
BOOL WCPointerIsValidObjcObject(const void * ptr);

#ifdef __cplusplus
}
#endif

