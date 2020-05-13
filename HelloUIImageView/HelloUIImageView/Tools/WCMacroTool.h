//
//  WCMacroTool.h
//  HelloUIImageView
//
//  Created by wesley_chen on 2020/5/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#ifndef WCMacroTool_h
#define WCMacroTool_h

/**
 macro for [UIImage imageNamed:@"xxx"]

 @param imageName the name of image
 @param resource_bundle the resource bundle (with .bundle) containes image. @"" is for main bundle
 @return the UIImage object
 */
#define UIImageInResourceBundle(imageName, resource_bundle)  ([UIImage imageNamed:[(resource_bundle) stringByAppendingPathComponent:(imageName)]])


#endif /* WCMacroTool_h */
