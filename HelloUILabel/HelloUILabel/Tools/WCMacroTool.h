//
//  WCMacroTool.h
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef UICOLOR_RGB
#define UICOLOR_RGB(color)       [UIColor colorWithRed: (((color) >> 16) & 0xFF) / 255.0 green: (((color) >> 8) & 0xFF) / 255.0 blue: ((color) & 0xFF) / 255.0 alpha: 1.0]
#endif

// use for initializing frame/size/point when change it afterward
#ifndef UNSPECIFIED
#define UNSPECIFIED 0
#endif
