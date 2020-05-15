//
//  WCMachOTool.m
//  HelloDyldFunctions
//
//  Created by wesley_chen on 2020/5/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCMachOTool.h"
#import <mach-o/dyld.h>
#import <mach-o/ldsyms.h>

#define SEMA_LOCK_INIT \
static dispatch_semaphore_t sLock; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
    sLock = dispatch_semaphore_create(1); \
});

#define SEMA_LOCK(...) \
dispatch_semaphore_wait(sLock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__ \
dispatch_semaphore_signal(sLock);

@implementation WCMachOTool

+ (NSString *)appExecutableImageLoadAddress {
    static NSString *sAddress;
    SEMA_LOCK_INIT;
    
    if (!sAddress) {
        SEMA_LOCK(
            const struct mach_header *executableHeader = NULL;
            for (uint32_t i = 0; i < _dyld_image_count(); i++) {
                const struct mach_header *header = _dyld_get_image_header(i);
                // Note: find the image type is executable, which is the executable binary file
                if (header->filetype == MH_EXECUTE) {
                    executableHeader = header;
                    break;
                }
            }
            sAddress = [NSString stringWithFormat:@"0x%lx", (long)executableHeader];
        );
    }
    
    return sAddress;
}

+ (nullable NSString *)appExecutableUUID {
    static NSString *sUUID;
    SEMA_LOCK_INIT;
    
    if (!sUUID) {
        SEMA_LOCK(
            const uint8_t *command = (const uint8_t *)(&_mh_execute_header + 1);
            for (uint32_t idx = 0; idx < _mh_execute_header.ncmds; ++idx) {
                if (((const struct load_command *)command)->cmd == LC_UUID) {
                    command += sizeof(struct load_command);
                    sUUID = [[NSString stringWithFormat:@"%02X%02X%02X%02X-%02X%02X-%02X%02X-%02X%02X-%02X%02X%02X%02X%02X%02X",
                             command[0], command[1],
                             command[2], command[3],
                             command[4], command[5],
                             command[6], command[7],
                             command[8], command[9],
                             command[10], command[11],
                             command[12], command[13],
                             command[14], command[15]] copy];
                    break;
                }
                else {
                    command += ((const struct load_command *)command)->cmdsize;
                }
            }
        );
    }

    return sUUID;
}

@end
