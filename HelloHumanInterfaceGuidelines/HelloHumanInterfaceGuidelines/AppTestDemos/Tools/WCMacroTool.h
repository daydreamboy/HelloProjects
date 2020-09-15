//
//  WCMacroTool.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

/**
 Create an immutable attributed string
 
 @param the string
 @return the attributed string
 */
#define ASTR(str) ([[NSAttributedString alloc] initWithString:[(id)(str) isKindOfClass:[NSString class]] ? (id)(str) : @""])

/**
 Create an immutable attributed string with attributes
 
 @param the string
 @param the attributes dictionary
 @return the attributed string
 */
#define ASTR2(str, attrs) ([[NSAttributedString alloc] initWithString:([(id)(str) isKindOfClass:[NSString class]] ? (id)(str) : @"") attributes:([(id)(attrs) isKindOfClass:[NSDictionary class]] ? (id)(attrs) : @{})])

#pragma mark - Mutable

/**
 Create a mutable attributed string
 
 @param the string
 @return the attributed string
 */
#define ASTR_M(str) ([[NSMutableAttributedString alloc] initWithString:[(id)(str) isKindOfClass:[NSString class]] ? (id)(str) : @""])

/**
 Create a mutable attributed string with attributes
 
 @param the string
 @param the attributes dictionary
 @return the attributed string
 */
#define ASTR2_M(str, attrs) ([[NSMutableAttributedString alloc] initWithString:([(id)(str) isKindOfClass:[NSString class]] ? (id)(str) : @"") attributes:([(id)(attrs) isKindOfClass:[NSDictionary class]] ? (id)(attrs) : @{})])

#ifndef UICOLOR_RGB
#define UICOLOR_RGB(color) ([UIColor colorWithRed: (((color) >> 16) & 0xFF) / 255.0 green: (((color) >> 8) & 0xFF) / 255.0 blue: ((color) & 0xFF) / 255.0 alpha: 1.0])
#endif

// 0xRRGGBBAA
#ifndef UICOLOR_RGBA
#define UICOLOR_RGBA(color) ([UIColor colorWithRed: (((color) >> 24) & 0xFF) / 255.0 green: (((color) >> 16) & 0xFF) / 255.0 blue: (((color) >> 8) & 0xFF) / 255.0 alpha: ((color) & 0xFF) / 255.0])
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

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

// >= `12.0`
#ifndef IOS12_OR_LATER
#define IOS12_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"12.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

#endif /* WCMacroTool_h */
