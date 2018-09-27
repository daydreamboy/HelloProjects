//
//  WCURLTool.m
//  HelloNSURL
//
//  Created by wesley_chen on 2018/7/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCURLTool.h"
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

@implementation WCURLQueryItem
+ (instancetype)queryItemWithName:(NSString *)name value:(NSString *)value {
    WCURLQueryItem *item = [WCURLQueryItem new];
    item.name = name;
    item.value = value;
    return item;
}
@end

@implementation WCURLComponents
@end

@implementation WCURLTool

+ (NSURL *)PNGImageURLWithImageName:(NSString *)imageName inResourceBundle:(NSString *)resourceBundleName {
    if (![imageName isKindOfClass:[NSString class]] || ![resourceBundleName isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    NSBundle *resourceBundle;
    NSString *resourceBundlePath;
    if (resourceBundleName) {
        resourceBundlePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:resourceBundleName];
        resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
    }
    else {
        resourceBundle = [NSBundle mainBundle];
        resourceBundlePath = [[NSBundle mainBundle] bundlePath];
    }
    
    NSArray *imageNames = @[
                            // image@2x.png
                            [NSString stringWithFormat:@"%@@%dx.png", imageName, (int)[UIScreen mainScreen].scale],
                            // iamge@2x.PNG
                            [NSString stringWithFormat:@"%@@%dx.PNG", imageName, (int)[UIScreen mainScreen].scale],
                            // image@2X.png
                            [NSString stringWithFormat:@"%@@%dX.png", imageName, (int)[UIScreen mainScreen].scale],
                            // image@2X.PNG
                            [NSString stringWithFormat:@"%@@%dX.png", imageName, (int)[UIScreen mainScreen].scale],
                            ];
    
    NSString *imageFileName = [imageNames firstObject];
    for (NSString *imageName in imageNames) {
        NSString *filePath = [resourceBundlePath stringByAppendingPathComponent:imageName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
            imageFileName = imageName;
            break;
        }
    }
    
    NSURL *URL = [resourceBundle URLForResource:[imageFileName stringByDeletingPathExtension] withExtension:[imageFileName pathExtension]];
    return URL;
}



+ (nullable WCURLComponents *)URLComponentsWithUrlString:(NSString *)urlString {
    if (![urlString isKindOfClass:[NSString class]] || urlString.length == 0) {
        return nil;
    }
    
    WCURLComponents *components = [[WCURLComponents alloc] init];
    
    // @see https://tools.ietf.org/html/rfc2396
    //                          12                3      4              5         6    7        8 9
    NSString *patternOfURI = @"^(([^:\\/\\?#]+):)?(\\/\\/([^\\/\\?#]*))?([^\\?#]*)(\\\?([^#]*))?(#(.*))?";
    
    // @see https://stackoverflow.com/a/39811696 e.g. <username>:<password>@<host>:<port>
    //                                           1       2         3            4
    NSString *patternOfAuthorityComponent = @"(?:([^:]*):([^@]*)@|)([^/:]{1,}):?(\\d*)?";
    
    // @see https://stackoverflow.com/a/39811696
    //                                   1              2
    NSString *patternOfPathComponent = @"(\\/[^;]{1,});?([^;]+)?";
    
    // @see https://stackoverflow.com/a/46885117
    //                                          1        2
    NSString *patternOfQueryItems = @"(?:^|[?&])([^=&]*)=([^=&]*)";
    
    NSTextCheckingResult *match = [self firstMatchInString:urlString pattern:patternOfURI];
    if (match.numberOfRanges == 10) {
        NSRange schemeRange = [match rangeAtIndex:2];
        NSRange authorityRange = [match rangeAtIndex:4];
        NSRange pathRange = [match rangeAtIndex:5];
        NSRange queryRange = [match rangeAtIndex:7];
        NSRange fragmentRange = [match rangeAtIndex:9];
        
        NSString *schemeComponent = [self substringWithString:urlString range:schemeRange];
        NSString *authorityComponent = [self substringWithString:urlString range:authorityRange];
        NSString *pathComponent = [self substringWithString:urlString range:pathRange];
        NSString *queryComponent = [self substringWithString:urlString range:queryRange];
        NSString *fragmentComponent = [self substringWithString:urlString range:fragmentRange];
        
        NSTextCheckingResult *matchOfAuthorityComponent = [self firstMatchInString:authorityComponent pattern:patternOfAuthorityComponent];
        if (matchOfAuthorityComponent.numberOfRanges == 5) {
            NSRange userRange = [matchOfAuthorityComponent rangeAtIndex:1];
            NSRange passwordRange = [matchOfAuthorityComponent rangeAtIndex:2];
            NSRange hostRange = [matchOfAuthorityComponent rangeAtIndex:3];
            NSRange portRange = [matchOfAuthorityComponent rangeAtIndex:4];
            
            components.user = [self substringWithString:authorityComponent range:userRange];
            components.password = [self substringWithString:authorityComponent range:passwordRange];
            components.host = [self substringWithString:authorityComponent range:hostRange];
            components.port = [self numberFromString:[self substringWithString:authorityComponent range:portRange] encodedType:@encode(int)];
        }
        
        NSTextCheckingResult *matchOfPathComponent = [self firstMatchInString:pathComponent pattern:patternOfPathComponent];
        if (matchOfPathComponent.numberOfRanges == 3) {
            NSRange wellKnownPathRange = [matchOfPathComponent rangeAtIndex:1];
            NSRange parameterRange = [matchOfPathComponent rangeAtIndex:2];
            
            components.path = [self substringWithString:pathComponent range:wellKnownPathRange];
            components.parameterString = [self substringWithString:pathComponent range:parameterRange];
        }
        
        components.string = urlString;
        components.scheme = schemeComponent;
        components.query = queryComponent;
        components.fragment = fragmentComponent;
        
        if (queryComponent.length) {
            NSMutableArray<WCURLQueryItem *> *queryItemsM = [NSMutableArray array];
            BOOL success = [self enumerateMatchesInString:queryComponent pattern:patternOfQueryItems usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                NSTextCheckingResult *matchOfQueryItems = result;
                
                if (matchOfQueryItems.numberOfRanges == 3) {
                    NSRange keyRange = [matchOfQueryItems rangeAtIndex:1];
                    NSRange valueRange = [matchOfQueryItems rangeAtIndex:2];
                    
                    NSString *key = [self substringWithString:queryComponent range:keyRange];
                    NSString *value = [self substringWithString:queryComponent range:valueRange];
                    
                    WCURLQueryItem *queryItem = [WCURLQueryItem queryItemWithName:key value:value];
                    queryItem.queryString = queryComponent;
                    [queryItemsM addObject:queryItem];
                }
            }];
            
            if (success && queryItemsM.count) {
                components.queryItems = queryItemsM;
            }
        }
    }
    
    return components;
}

#pragma mark - Utility Methods

+ (BOOL)enumerateMatchesInString:(NSString *)string pattern:(NSString *)pattern usingBlock:(void (^)(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop))block {
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || ![pattern isKindOfClass:[NSString class]] || pattern.length == 0) {
        return NO;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    if (error) {
        return NO;
    }
    
    if (block) {
        [regex enumerateMatchesInString:string options:kNilOptions range:NSMakeRange(0, string.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
            BOOL shouldStop = NO;
            block(result, flags, &shouldStop);
            *stop = shouldStop;
        }];
        
        return YES;
    }
    else {
        return NO;
    }
}

+ (nullable NSTextCheckingResult *)firstMatchInString:(NSString *)string pattern:(NSString *)pattern {
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || ![pattern isKindOfClass:[NSString class]] || pattern.length == 0) {
        return nil;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    if (error) {
        return nil;
    }
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    return match;
}

+ (nullable NSString *)substringWithString:(NSString *)string range:(NSRange)range {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    if (range.location < string.length) {
        if (range.location + range.length <= string.length) {
            return [string substringWithRange:range];
        }
        else {
            return nil;;
        }
    }
    else {
        return nil;
    }
}

+ (nullable NSNumber *)numberFromString:(NSString *)string encodedType:(char *)encodedType {
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || encodedType == NULL) {
        return nil;
    }
    
    NSNumber *number = nil;
    
    if (strcmp(encodedType, @encode(BOOL)) == 0) {
        BOOL value = [string boolValue];
        number = [NSNumber numberWithBool:value];
    }
    else {
        NSCharacterSet *subSet = [NSCharacterSet characterSetWithCharactersInString:string];
        NSCharacterSet *superSet = [NSCharacterSet characterSetWithCharactersInString:@"-.0123456789"];
        if (![superSet isSupersetOfSet:subSet]) {
            return nil;
        }
        
        // Note: NSString provides doubleValue/floatValue/intValue/longLongValue/boolValue
        if (strcmp(encodedType, @encode(double)) == 0) {
            double value = [string doubleValue];
            number = [NSNumber numberWithDouble:value];
        }
        else if (strcmp(encodedType, @encode(float)) == 0) {
            float value = [string floatValue];
            number = [NSNumber numberWithFloat:value];
        }
        else if (strcmp(encodedType, @encode(int)) == 0) {
            int value = [string intValue];
            number = [NSNumber numberWithInt:value];
        }
        else if (strcmp(encodedType, @encode(NSInteger)) == 0 ||
                 strcmp(encodedType, @encode(long long)) == 0 ||
                 strcmp(encodedType, @encode(long)) == 0) {
            long long value = [string longLongValue];
            number = [NSNumber numberWithLongLong:value];
        }
    }
    
    return number;
}

@end
