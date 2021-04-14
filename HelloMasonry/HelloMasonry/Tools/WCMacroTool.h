//
//  WCMacroTool.h
//  HelloMasonry
//
//  Created by wesley_chen on 2021/4/14.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

// 0xRRGGBB
#ifndef UICOLOR_RGB
#define UICOLOR_RGB(color) ([UIColor colorWithRed: (((color) >> 16) & 0xFF) / 255.0 green: (((color) >> 8) & 0xFF) / 255.0 blue: ((color) & 0xFF) / 255.0 alpha: 1.0])
#endif

#endif /* WCMacroTool_h */
