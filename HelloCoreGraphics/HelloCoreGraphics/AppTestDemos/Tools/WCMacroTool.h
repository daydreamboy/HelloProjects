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

#ifndef UICOLOR_RGB
#define UICOLOR_RGB(color)       [UIColor colorWithRed: (((color) >> 16) & 0xFF) / 255.0 green: (((color) >> 8) & 0xFF) / 255.0 blue: ((color) & 0xFF) / 255.0 alpha: 1.0]
#endif

#endif /* WCMacroTool_h */
