//
//  WCIconFontTool.m
//  HelloUIFont
//
//  Created by wesley_chen on 2020/4/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCIconFontTool.h"
#import <CoreText/CoreText.h>

/**
 Safe set pointer's value
 
 @param ptr the pointer
 @param value the value which ptr points to
 */
#define PTR_SAFE_SET(ptr, value) \
do { \
    if (ptr) { \
        *ptr = value; \
    } \
} while (0)

@implementation WCIconFontTool

+ (BOOL)registerIconFontWithFilePath:(NSString *)filePath fontName:(NSString * _Nullable * _Nullable)fontName error:(NSError * _Nullable * _Nullable)error {
    
    if (![filePath isKindOfClass:[NSString class]]) {
        PTR_SAFE_SET(error, [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{ NSLocalizedDescriptionKey: @"filePath is not a NSString" }]);
        return NO;
    }
    
    if (!filePath.length) {
        PTR_SAFE_SET(error, [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{ NSLocalizedDescriptionKey: @"filePath is empty" }]);
        return NO;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [self registerIconFontWithData:data fontName:fontName error:error];
}

+ (BOOL)registerIconFontWithData:(NSData *)data fontName:(NSString * _Nullable * _Nullable)fontName error:(NSError * _Nullable * _Nullable)error {
    
    if (!data.length) {
        PTR_SAFE_SET(error, [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{ NSLocalizedDescriptionKey: @"data is empty" }]);

        return NO;
    }
    
    CFErrorRef errorRef;
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)data);
    CGFontRef fontRef = CGFontCreateWithDataProvider(provider);
    
    if (!fontRef) {
        PTR_SAFE_SET(error, [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{ NSLocalizedDescriptionKey: @"fontRef is NULL" }]);
        return NO;
    }
    
    CFStringRef fontNameRef = CGFontCopyPostScriptName(fontRef);
    if (fontNameRef) {
        NSString *fontNameL = (__bridge_transfer NSString *)(fontNameRef);
        PTR_SAFE_SET(fontName, [fontNameL copy]);
    }
    
    bool success = CTFontManagerRegisterGraphicsFont(fontRef, &errorRef);
    
    NSError *errorL = (__bridge NSError *)errorRef;
    PTR_SAFE_SET(error, errorL);
    
    CFRelease(fontRef);
    CFRelease(provider);
    
    return success;
}

+ (BOOL)unregisterIconFontWithName:(NSString *)name error:(NSError * _Nullable * _Nullable)error completionHandler:(void (^)(NSError *error))completionHandler {
    if (![name isKindOfClass:[NSString class]]) {
        PTR_SAFE_SET(error, [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{ NSLocalizedDescriptionKey: @"name is not a NSString" }]);
        return NO;
    }
    
    CGFontRef fontRef = CGFontCreateWithFontName((CFStringRef)name);
    if (!fontRef) {
        NSString *description = [NSString stringWithFormat:@"%@ font not found", name];
        PTR_SAFE_SET(error, [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{ NSLocalizedDescriptionKey: description }]);
        return NO;
    }
    
    CFErrorRef errorRef;
    bool success = !CTFontManagerUnregisterGraphicsFont(fontRef, &errorRef);
    
    NSError *errorL = (__bridge NSError *)errorRef;
    PTR_SAFE_SET(error, errorL);
    
    CFRelease(fontRef);
    return success;
}

+ (nullable UIFont *)fontWithName:(NSString *)fontName fontSize:(CGFloat)fontSize {
    if (![fontName isKindOfClass:[NSString class]] || !fontName.length) {
        return nil;
    }
    
    if (fontSize <= 0.0) {
        return nil;
    }
    
    return [UIFont fontWithName:fontName size:fontSize];
}

+ (UIImage *)imageWithIconFontName:(NSString *)iconFontName text:(NSString *)text fontSize:(CGFloat)fontSize color:(UIColor *)color {
    UILabel *label = [[UILabel alloc] init];
    label.font = [self fontWithName:iconFontName fontSize:fontSize];
    label.text = text;
    label.textColor = color;
    [label sizeToFit];
    
    UIGraphicsBeginImageContextWithOptions(label.bounds.size, NO, 0);
    [label.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
