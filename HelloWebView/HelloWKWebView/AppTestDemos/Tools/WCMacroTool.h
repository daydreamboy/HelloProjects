//
//  WCMacroTool.h
//  HelloWebView
//
//  Created by wesley_chen on 2020/1/9.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

// Is a string and not empty after trim
#define STR_TRIM_IF_NOT_EMPTY(str)   ([(str) isKindOfClass:[NSString class]] && [[(NSString *)(str) stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length])

#define STR_OF_JSON(...) @#__VA_ARGS__

#endif /* WCMacroTool_h */
