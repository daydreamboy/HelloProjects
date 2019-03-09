//
//  WCMacroTool.h
//  HelloUIAlertController
//
//  Created by wesley_chen on 2019/3/9.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

#import "WCMacroToolBackend.h"

#pragma mark - va_list to NSArray

/**
 Convert va_list to NSArray

 @param _theFirst the first parameter which followed by variable arguments
 @return the array from va_list
 @see https://stackoverflow.com/a/449721
 @code
 - (void)someMethod:(NSString *)sql, ...
 {
    NSArray *args = NSArrayFromVaList(sql);
    // Do stuff with args
 }
 @endcode
 */
#define NSArrayFromVaList(_theFirst) ({ \
    va_list ap; \
    va_start(ap, _theFirst); \
    NSArray *__args = [WCMacroToolBackend arrayFromVaList:ap]; \
    va_end(ap); \
    __args; \
})

#endif /* WCMacroTool_h */
