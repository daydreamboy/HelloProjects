//
//  WCMachOTool.h
//  HelloDyldFunctions
//
//  Created by wesley_chen on 2020/5/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCMachOTool : NSObject
@end

@interface WCMachOTool ()

#pragma mark - App Executable Image on Runtime

/**
 Get the app executable image load address
 
 @return the app executable image load address, e.g. 0x104ffc000
 @header #import <mach-o/dyld.h>
 @see https://www.wandouip.com/t5i276951/
 */
+ (NSString *)appExecutableImageLoadAddress;

/**
 Get the UUID of the app executable image
 
 @return the UUID
 @header #import <mach-o/ldsyms.h>
 @see https://stackoverflow.com/questions/10119700/how-to-get-mach-o-uuid-of-a-running-process
 
 @discussion use the following command to check the app executable file
 @code
 $ otool -l <app executable file> | grep uuid
 @endcode
 */
+ (nullable NSString *)appExecutableUUID;

@end

NS_ASSUME_NONNULL_END
