//
//  WCMacroTool.h
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/6/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

#pragma mark > Frame

/**
 Set width and height of a frame

 @param frame the original frame
 @param newWidth the new width. If not change, set it to NAN
 @param newHeight the new height. If not change, set it to NAN
 @return the new frame
 @discussion Use FrameSet macro in WCViewTool instead.
 */
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

#ifndef UICOLOR_RGB
#define UICOLOR_RGB(color)       [UIColor colorWithRed: (((color) >> 16) & 0xFF) / 255.0 green: (((color) >> 8) & 0xFF) / 255.0 blue: ((color) & 0xFF) / 255.0 alpha: 1.0]
#endif

/// Private: for STR_OF_LITERAL macro
#define __STRINGFY(a) @#a
/**
 Get a literal string from literal text
 
 @param literal_ the literal text or a macro
 @return the literal string
 */
#define STR_OF_LITERAL(literal_) __STRINGFY(literal_)


#define DRAWING_VIEW_CLASS(identifier_) MyDrawingView##identifier_
#define DRAWING_VIEW_CLASS_PREFIX       @"MyDrawingView"

#define DRAWING_VIEW_CLASS_DECLARATION_BEGIN(identifier_) @interface DRAWING_VIEW_CLASS(identifier_) : UIView
#define DRAWING_VIEW_CLASS_DECLARATION_END @end

#define DRAWING_VIEW_CLASS_IMPLEMENTATION_BEGIN(identifier_) @implementation DRAWING_VIEW_CLASS(identifier_)
#define DRAWING_VIEW_CLASS_IMPLEMENTATION_END @end

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
