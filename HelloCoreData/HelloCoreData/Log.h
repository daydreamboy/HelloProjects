//
//  Log.h
//  HelloCoreData
//
//  Created by wesley_chen on 12/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#ifndef Log_h
#define Log_h

#define MODULE_NAME        @"HelloCoreData"

#ifdef MODULE_NAME
#   define MODULE_NAME_STR [NSString stringWithFormat:@"[%@]", MODULE_NAME]
#else
#   define MODULE_NAME_STR @""
#endif

#ifndef __FILE_NAME__
#define __FILE_NAME__      ((strrchr(__FILE__, '/') ? : __FILE__ - 1) + 1)
#endif

// XLog format: [<log level>][<module name>] <method name>(<filename.m>:<line number>) <log message here...>

#   define ALog(fmt, ...) { NSLog((@"[Alert]%@ %@(%@:%@) " fmt), MODULE_NAME_STR, @(__PRETTY_FUNCTION__), @(__FILE_NAME__), @(__LINE__),  ## __VA_ARGS__); }
#   define CLog(fmt, ...) { NSLog((@"[Critical]%@ %@(%@:%@) " fmt), MODULE_NAME_STR, @(__PRETTY_FUNCTION__), @(__FILE_NAME__), @(__LINE__), ## __VA_ARGS__); }
#   define ELog(fmt, ...) { NSLog((@"[Error]%@ %@(%@:%@) " fmt), MODULE_NAME_STR, @(__PRETTY_FUNCTION__), @(__FILE_NAME__), @(__LINE__), ## __VA_ARGS__); }
#   define WLog(fmt, ...) { NSLog((@"[Warning]%@ " fmt), MODULE_NAME_STR,  ## __VA_ARGS__); }

#ifdef DEBUG
#   define NLog(fmt, ...) { NSLog((@"[Notice]%@ " fmt), MODULE_NAME_STR, ## __VA_ARGS__); }
#   define ILog(fmt, ...) { NSLog((@"[Info]%@ " fmt), MODULE_NAME_STR, ## __VA_ARGS__); }
#   define DLog(fmt, ...) { NSLog((@"[Debug]%@ %@(%@:%@) " fmt), MODULE_NAME_STR, @(__PRETTY_FUNCTION__), @(__FILE_NAME__), @(__LINE__), ## __VA_ARGS__); }
#else
#   define NLog(fmt, ...)
#   define ILog(fmt, ...)
#   define DLog(fmt, ...)
#endif

/**
 *  Log NSError if needed
 *
 *  @param err a NSError object
 */
#ifndef LogError
#define LogError(err)       \
{                           \
    if (err) {              \
        ELog(@"%@", err);   \
    }                       \
}
#endif

#endif /* Log_h */
