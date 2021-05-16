//
//  WCMacroTool.h
//  HelloNSObject
//
//  Created by wesley_chen on 2021/5/16.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

#define primitiveValueFromNSValue(nsValue_, primitiveType_) \
({ \
primitiveType_ outValue__; \
if (([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)) { \
    [nsValue_ getValue:&outValue__]; \
} \
else { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wunguarded-availability\"") \
    [nsValue_ getValue:&outValue__ size:sizeof(primitiveType_)]; \
_Pragma("clang diagnostic pop") \
} \
outValue__; \
});

#endif /* WCMacroTool_h */
