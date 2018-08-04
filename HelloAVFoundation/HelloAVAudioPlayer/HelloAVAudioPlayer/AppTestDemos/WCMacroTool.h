//
//  WCMacroTool.h
//  HelloAVAudioPlayer
//
//  Created by wesley_chen on 2018/8/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef PathForResourceInBundle
/**
 Get the path of resource file (e.g. plist)
 
 @param resource_name the resource file name with extension
 @param resource_bundle the resource bundle name without .bundle. If nil, use main bundle (.app)
 @return the path. If not exists, return nil
 */
#define PathForResourceInBundle(resource_name, resource_bundle) \
( \
(resource_bundle != nil) \
? ([[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:(resource_bundle) ofType:@"bundle"]] pathForResource:[(resource_name) stringByDeletingPathExtension] ofType:[(resource_name) pathExtension]]) \
: ([[NSBundle mainBundle] pathForResource:[(resource_name) stringByDeletingPathExtension] ofType:[(resource_name) pathExtension]]) \
)
#endif

#ifndef URLForResourceInBundle
/**
 Get the URL of resource file (e.g. plist)

 @param resource_name the resource file name with extension
 @param resource_bundle the resource bundle name without .bundle. If nil, use main bundle (.app)
 @return the path. If not exists, return nil
 */
#define URLForResourceInBundle(resource_name, resource_bundle) \
( \
(resource_bundle != nil) \
? ([[NSBundle bundleWithURL:[[NSBundle mainBundle] URLForResource:(resource_bundle) withExtension:@"bundle"]] URLForResource:[(resource_name) stringByDeletingPathExtension] withExtension:[(resource_name) pathExtension]]) \
: ([[NSBundle mainBundle] URLForResource:[(resource_name) stringByDeletingPathExtension] withExtension:[(resource_name) pathExtension]]) \
)
#endif

#define WCSafeSetErrorPtr(errorPtr, error) \
do { \
    if (errorPtr) { \
        *errorPtr = error; \
    } \
} while (0)
