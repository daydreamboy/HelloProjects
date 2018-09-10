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


@implementation NSURLComponents (parameterString)
@dynamic parameterString;
- (void)setParameterString:(NSString *)parameterString {
    objc_setAssociatedObject(self, @selector(parameterString), parameterString, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSString *)parameterString {
    return objc_getAssociatedObject(self, @selector(parameterString));
}
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

+ (nullable NSURLComponents *)URLComponentsWithUrlString:(NSString *)urlString {
    NSString *pattern = @"^(([^:\\/\\?#]+):)?(\\/\\/([^\\/\\?#]*))?([^\\?#]*)(\\\?([^#]*))?(#(.*))?";
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive | NSRegularExpressionAnchorsMatchLines error:&error];
    NSTextCheckingResult *match = [regex firstMatchInString:urlString options:kNilOptions range:NSMakeRange(0, urlString.length)];
    if (match.numberOfRanges == 10) {
        NSRange schemeRange = [match rangeAtIndex:2];
        NSRange authorityRange = [match rangeAtIndex:4];
        NSRange pathRange = [match rangeAtIndex:5];
        NSRange queryRange = [match rangeAtIndex:7];
        NSRange fragmentRange = [match rangeAtIndex:9];
        
        NSString *schemePart = [self substringWithString:urlString range:schemeRange];
        NSString *authorityPart = [self substringWithString:urlString range:authorityRange];
        NSString *path = [self substringWithString:urlString range:pathRange];
        NSString *query = [self substringWithString:urlString range:queryRange];
        NSString *fragment = [self substringWithString:urlString range:fragmentRange];
        
        // TODO: [userinfo@]host[:port]
        
//        NSString *host = [[authorityPart componentsSeparatedByString:@":"] firstObject];
//        NSString *port = [[authorityPart componentsSeparatedByString:@":"] lastObject];
//        NSString *path2 = [[path componentsSeparatedByString:@";"] firstObject];
        /*
        NSURLComponents *components = [[NSURLComponents alloc] init];
        components.fragment = fragment;
        components.host = host;
        components.password = nil;
        components.path = path2;
        components.port = @([port integerValue]);
        components.parameterString = nil; // TODO
        components.query = query;
        components.queryItems = nil; // TODO
        components.scheme = schemePart;
        components.user = nil; // TODO
        
        NSLog(@"test");
        
        return components;
         */
    }
    
    return nil;
}

+ (nullable NSString *)substringWithString:(NSString *)string range:(NSRange)range {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (range.location == NSNotFound || range.length == 0) {
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

@end
