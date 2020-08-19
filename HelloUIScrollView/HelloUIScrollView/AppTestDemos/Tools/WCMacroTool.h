//
//  WCMacroTool.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/10.
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

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

#endif /* WCMacroTool_h */
