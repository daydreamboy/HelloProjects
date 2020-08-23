//
//  WCFontTool.m
//  HelloUIFont
//
//  Created by wesley_chen on 2018/11/30.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCFontTool.h"
#import <CoreText/CoreText.h>
#import <CoreFoundation/CoreFoundation.h>

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

@interface WCFontGlyphInfo ()
@property (nonatomic, assign, readwrite) UTF16Char unicode;
@property (nonatomic, assign, readwrite) CGFontIndex index;
@property (nonatomic, copy, readwrite) NSString *name;
@property (nonatomic, copy, readwrite) NSString *character;
@property (nonatomic, copy, readwrite) NSString *unicodeString;
@property (nonatomic, assign, readwrite) CGRect boundingRect;
@property (nonatomic, assign, readwrite) CTFontRef fontRef;
@end

@implementation WCFontGlyphInfo

- (CGPathRef)pathWithTransform:(CGAffineTransform)transform {
    // !!!: How to release this path 
    CGPathRef path = CTFontCreatePathForGlyph(_fontRef, _index, &transform);
    
    return path;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@ : %p, unicode: %X; index = %@; name = %@; char = %@", NSStringFromClass([self class]), self, _unicode, @(_index), _name, _character];
}

@end

@interface WCFontInfo ()
@property (nonatomic, strong, readwrite) NSArray<WCFontGlyphInfo *> *glyphInfos;
@property (nonatomic, copy, readwrite) NSString *fileName;
@property (nonatomic, copy, readwrite) NSString *filePath;
@property (nonatomic, copy, readwrite) NSString *postScriptName;
@property (nonatomic, copy, readwrite) NSString *familyName;
@property (nonatomic, copy, readwrite) NSString *fullName;
@property (nonatomic, copy, readwrite) NSString *displayName;
@property (nonatomic, assign, readwrite) CGFloat ascent;
@property (nonatomic, assign, readwrite) CGFloat descent;
@property (nonatomic, assign, readwrite) CGFloat leading;
@property (nonatomic, assign, readwrite) CGFloat capHeight;
@property (nonatomic, assign, readwrite) CGFloat xHeight;
@property (nonatomic, assign, readwrite) CGFloat slantAngle;
@property (nonatomic, assign, readwrite) CGFloat underlineThickness;
@property (nonatomic, assign, readwrite) CGFloat underlinePosition;
@property (nonatomic, assign, readwrite) CGRect boundingBox;
@property (nonatomic, assign, readwrite) unsigned int unitsPerEm;
@property (nonatomic, assign, readwrite) CTFontRef fontRef;
@end

@implementation WCFontInfo

- (void)dealloc {
    if (_fontRef) {
        CFRelease(_fontRef);
    }
}

@end


@implementation WCFontTool

#pragma mark - Get Font Names

+ (NSDictionary<NSString *, NSArray *> *)allFontNamesTable {
    static NSMutableDictionary *sTable;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sTable = [NSMutableDictionary dictionary];
        
        NSArray<NSString *> *familyNames = [UIFont familyNames];
        for (NSString *familyName in familyNames) {
            NSMutableArray *sortedFontNames = [NSMutableArray array];
            NSArray *fontNames = [UIFont fontNamesForFamilyName:familyName];
            if (fontNames.count) {
                [sortedFontNames addObjectsFromArray:fontNames];
                [sortedFontNames sortUsingSelector:@selector(compare:)];
            }
            sTable[familyName] = sortedFontNames;
        }
    });
    
    return sTable;
}

+ (NSArray<NSString *> *)allFontFamilyNames {
    static NSArray *sSortedFontFamilyNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sSortedFontFamilyNames = [[[self allFontNamesTable] allKeys] sortedArrayUsingSelector:@selector(compare:)];
    });
    
    return sSortedFontFamilyNames;
}

+ (NSArray<NSString *> *)allFontNames {
    static NSMutableArray *sFontNames;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sFontNames = [NSMutableArray array];
        [[self allFontNamesTable] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSArray * _Nonnull obj, BOOL * _Nonnull stop) {
            [sFontNames addObjectsFromArray:obj];
        }];
        [sFontNames sortUsingSelector:@selector(compare:)];
    });
    
    return sFontNames;
}

#pragma mark - Get Font

+ (nullable UIFont *)fontWithFormattedName:(NSString *)formattedName {
    if (![formattedName isKindOfClass:[NSString class]] || formattedName.length == 0) {
        return nil;
    }
    
    UIFont *font;
    NSArray *parts = [formattedName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (parts.count >= 2) {
        NSString *fontName = parts[0];
        CGFloat fontSize = [parts[1] doubleValue];
        
        if (fontName.length && fontSize > 0) {
            font = [UIFont fontWithName:fontName size:fontSize];
        }
        
        // Check system font
        if (!font) {
            font = [self systemFontWithFormattedName:formattedName];
        }
    }
    
    return font;
}

+ (nullable UIFont *)systemFontWithFormattedName:(NSString *)formattedName {
    if (![formattedName isKindOfClass:[NSString class]] || formattedName.length == 0) {
        return nil;
    }
    
    UIFont *font;
    NSArray *parts = [formattedName componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (parts.count >= 2) {
        NSString *fontName = parts[0];
        CGFloat fontSize = [parts[1] doubleValue];
        
        if (fontName.length && fontSize > 0) {
            if ([fontName isEqualToString:@"System"]) {
                font = [UIFont systemFontOfSize:fontSize];
            }
            else if ([fontName isEqualToString:@"System-Bold"]) {
                font = [UIFont boldSystemFontOfSize:fontSize];
            }
            else if ([fontName isEqualToString:@"System-Italic"]) {
                font = [UIFont italicSystemFontOfSize:fontSize];
            }
        }
    }
    
    return font;
}


+ (BOOL)registerFontWithFilePath:(NSString *)filePath fontName:(NSString * _Nullable * _Nullable)fontName error:(NSError * _Nullable * _Nullable)error {
    
    if (![filePath isKindOfClass:[NSString class]]) {
        PTR_SAFE_SET(error, [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{ NSLocalizedDescriptionKey: @"filePath is not a NSString" }]);
        return NO;
    }
    
    if (!filePath.length) {
        PTR_SAFE_SET(error, [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{ NSLocalizedDescriptionKey: @"filePath is empty" }]);
        return NO;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return [self registerFontWithData:data fontName:fontName error:error];
}

+ (BOOL)registerFontWithData:(NSData *)data fontName:(NSString * _Nullable * _Nullable)fontName error:(NSError * _Nullable * _Nullable)error {
    
    if (!data.length) {
        PTR_SAFE_SET(error, [NSError errorWithDomain:NSStringFromClass([self class]) code:-1 userInfo:@{ NSLocalizedDescriptionKey: @"data is empty" }]);

        return NO;
    }
    
    CFErrorRef errorRef = NULL;
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

+ (BOOL)unregisterIconFontWithName:(NSString *)name error:(NSError * _Nullable * _Nullable)error completionHandler:(nullable void (^)(NSError *error))completionHandler {
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
    
    CFErrorRef errorRef = NULL;
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

#pragma mark - Icon Image

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

#pragma mark - Icon Text

+ (nullable NSString *)unicodePointStringWithIconText:(NSString *)iconText {
    if (![iconText isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // A -> \U00000041, so length multiply by 10
    NSMutableString *unicodePointString = [NSMutableString stringWithCapacity:iconText.length * 10];
    
    [iconText enumerateSubstringsInRange:NSMakeRange(0, iconText.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSUInteger lengthByUnichar = [substring length];
        
        if (lengthByUnichar == 1) {
            unichar buffer[2] = {0};
            
            [substring getBytes:buffer maxLength:sizeof(unichar) usedLength:NULL encoding:NSUTF16StringEncoding options:0 range:NSMakeRange(0, substring.length) remainingRange:NULL];
            
            [unicodePointString appendFormat:@"\\U%08X", buffer[0]];
        }
        else if (lengthByUnichar == 2) {
            unsigned int buffer[2] = {0};
            
            [substring getBytes:buffer maxLength:sizeof(unsigned int) usedLength:NULL encoding:NSUTF32StringEncoding options:0 range:NSMakeRange(0, substring.length) remainingRange:NULL];
            
            [unicodePointString appendFormat:@"\\U%08X", buffer[0]];
        }
    }];

    return unicodePointString;
}

#pragma mark - Font File Info

+ (nullable WCFontInfo *)fontInfoWithFilePath:(NSString *)filePath {
    if (![filePath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    BOOL isDirectory = NO;
    if (![[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDirectory]) {
        return nil;
    }
    
    if (isDirectory) {
        return nil;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData((CFDataRef)data);
    
    // @see https://stackoverflow.com/a/9821608
    CGFontRef cgFontRef = CGFontCreateWithDataProvider(providerRef);
    CTFontRef ctFontRef = CTFontCreateWithGraphicsFont(cgFontRef, 0.0, NULL, NULL);

    WCFontInfo *fontInfo = [[WCFontInfo alloc] init];
    fontInfo.fontRef = ctFontRef;
    fontInfo.filePath = filePath;
    fontInfo.fileName = [filePath lastPathComponent];
    
    // Note: use __bridge_transfer, @see https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFDesignConcepts/Articles/tollFreeBridgedTypes.html#:~:text=__bridge%20transfers%20a%20pointer,with%20no%20transfer%20of%20ownership.&text=__bridge_transfer%20or%20CFBridgingRelease%20moves,relinquishing%20ownership%20of%20the%20object.
    fontInfo.postScriptName = (__bridge_transfer NSString *)(CTFontCopyPostScriptName(ctFontRef));
    fontInfo.familyName = (__bridge_transfer NSString *)(CTFontCopyFamilyName(ctFontRef));
    fontInfo.fullName = (__bridge_transfer NSString *)(CTFontCopyFullName(ctFontRef));
    fontInfo.displayName = (__bridge_transfer NSString *)(CTFontCopyDisplayName(ctFontRef));
    fontInfo.ascent = CTFontGetAscent(ctFontRef);
    fontInfo.descent = CTFontGetDescent(ctFontRef);
    fontInfo.leading = CTFontGetLeading(ctFontRef);
    fontInfo.capHeight = CTFontGetCapHeight(ctFontRef);
    fontInfo.xHeight = CTFontGetXHeight(ctFontRef);
    fontInfo.slantAngle = CTFontGetSlantAngle(ctFontRef);
    fontInfo.underlineThickness = CTFontGetUnderlineThickness(ctFontRef);
    fontInfo.underlinePosition = CTFontGetUnderlinePosition(ctFontRef);
    fontInfo.boundingBox = CTFontGetBoundingBox(ctFontRef);
    fontInfo.unitsPerEm = CTFontGetUnitsPerEm(ctFontRef);
    
    CFIndex numberOfGlyphs = CTFontGetGlyphCount(ctFontRef);
    CFCharacterSetRef characterSetRef = CTFontCopyCharacterSet(ctFontRef);
    
    NSMutableArray *glyphInfos = [NSMutableArray arrayWithCapacity:numberOfGlyphs];
    
    // @see https://stackoverflow.com/a/56785522
    for (int plane = 0; plane <= 16; ++plane) {
        if (CFCharacterSetHasMemberInPlane(characterSetRef, plane)) {
            UTF32Char c;
            for (c = plane << 16; c < (plane + 1) << 16; ++c) {
                if (CFCharacterSetIsCharacterMember(characterSetRef, c) && c <= USHRT_MAX) {
                    UniChar unicodes[1] = { c };
                    CGGlyph glyphs[1];
                    
                    bool valid = CTFontGetGlyphsForCharacters(ctFontRef, unicodes, glyphs, 1);
                    if (valid) {
                        CGGlyph glyph = glyphs[0];
                        
                        WCFontGlyphInfo *glyphInfo = [WCFontGlyphInfo new];
                        glyphInfo.fontRef = ctFontRef;
                        glyphInfo.index = glyph;
                        glyphInfo.name = (__bridge_transfer NSString *)CGFontCopyGlyphNameForGlyph(cgFontRef, glyph);
                        glyphInfo.unicode = c;
                        glyphInfo.unicodeString = [NSString stringWithFormat:@"%X", c];
                        glyphInfo.character = [NSString stringWithFormat:@"%C", unicodes[0]];
                        
                        CGRect boundings[1] = { CGRectZero };
                        CTFontGetBoundingRectsForGlyphs(ctFontRef, kCTFontOrientationDefault, glyphs, boundings, 1);
                        glyphInfo.boundingRect = boundings[0];
                        
                        [glyphInfos addObject:glyphInfo];
                    }
                }
            }
        }
    }
    fontInfo.glyphInfos = [glyphInfos copy];

    CFRelease(characterSetRef);
    //CFRelease(ctFontRef);
    CFRelease(cgFontRef);
    CFRelease(providerRef);
    
    return fontInfo;
}

@end
