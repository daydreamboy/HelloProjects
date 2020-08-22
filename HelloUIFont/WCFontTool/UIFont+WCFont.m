//
//  UIFont+WCFont.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UIFont+WCFont.h"
#import <CoreText/CoreText.h>

@implementation UIFont (WCFont)

+ (void)tbfont_registerFontWithData:(NSData *)data completionHandler:(void (^NS_NOESCAPE)(NSString *fontName, NSError *error))completionHandler {
    
    NSError *error = nil;
    NSString *fontNameRegistered = nil;
    
    if (data) {
        CFErrorRef errorRef;
        CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
        CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
        if(!CTFontManagerRegisterGraphicsFont(fontRef, &errorRef)){
            CFStringRef errorDescription = CFErrorCopyDescription(errorRef);
            NSString *errorDescriptionString = (__bridge NSString *)(errorDescription);
//            if (errorDescriptionString) {
            error = [NSError errorWithDomain:@"TBIconFontError" code:1 userInfo:@{NSLocalizedDescriptionKey: errorDescriptionString}];
//            }
            
            CFRelease(errorDescription);
        } else {
            CFStringRef fontNameRef = CGFontCopyPostScriptName(fontRef);
            if (fontNameRef) {
                fontNameRegistered = (__bridge_transfer NSString *)(fontNameRef);
            }
        }
        
        CFRelease(fontRef);
        CFRelease(provider);
    } else {
        error = [NSError errorWithDomain:@"TBIconFontError" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Font data is nil."}];
    }
    
    if (completionHandler) {
        completionHandler(fontNameRegistered, error);
    }

}

+ (void)tbfont_registerFontWithFilePath:(NSString *)fontFilePath completionHandler:(void (NS_NOESCAPE ^)(NSString *fontName, NSError *error))completionHandler{
    
    NSData *data = [[NSFileManager defaultManager] contentsAtPath:fontFilePath];
    
    [self tbfont_registerFontWithData:data completionHandler:completionHandler];
}

+ (void)tbfont_unregisterFontWithName:(NSString *)name completionHandler:(void (^)(NSError *error))completionHandler {
    NSError *error = nil;
    CGFontRef fontRef = CGFontCreateWithFontName((CFStringRef)name);
    if (fontRef) {
        CFErrorRef errorRef;
        if (!CTFontManagerUnregisterGraphicsFont(fontRef, &errorRef)) {
            CFStringRef errorDescription = CFErrorCopyDescription(errorRef);
            NSString *errorDescriptionString = (__bridge NSString *)(errorDescription);
            //            if (errorDescriptionString) {
            error = [NSError errorWithDomain:@"TBIconFontError" code:2 userInfo:@{NSLocalizedDescriptionKey: errorDescriptionString}];
//            }
            
            CFRelease(errorDescription);
        }
        CFRelease(fontRef);
    }
    
    if (completionHandler) {
        completionHandler(error);
    }
}

@end
