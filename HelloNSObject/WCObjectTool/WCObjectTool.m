//
//  WCObjectTool.m
//  HelloNSObject
//
//  Created by wesley_chen on 2019/3/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCObjectTool.h"
#import <objc/runtime.h>

// 4 spaces for indentation
#define INDENTATION @"    "

@implementation WCObjectTool

#pragma mark - Inspection

#pragma mark > Dump

+ (void)dumpWithObject:(NSObject *)object {
    printf("%s\n", [[self dumpedStringWithObject:object] UTF8String]);
}

+ (nullable NSString *)dumpedStringWithObject:(NSObject *)object {
    if (![object isKindOfClass:[NSObject class]]) {
        return nil;
    }
    
    NSMutableString *stringM = [NSMutableString string];
    traverse_object(stringM, object, 0, NO);
    
    return [stringM copy];
}

#pragma mark ::

static void traverse_object(NSMutableString *stringM, id object, NSUInteger depth, BOOL isValueForKey) {
    
    if (isValueForKey) {
        // hanlde value if it has a counter-part key
        [stringM appendString:@" : "];
    }
    else {
        // handle indentation
        for (NSUInteger i = 0; i < depth; i++) {
            [stringM appendString:INDENTATION];
        }
    }
    
    if ([object isKindOfClass:[NSDictionary class]]) {
        
        [stringM appendString:@"{\n"];
        
        NSArray *allKeys = [[object allKeys] sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull key1, id _Nonnull key2) {
            if ([[key1 description] compare:[key2 description]] == NSOrderedAscending) {
                return NSOrderedAscending;
            }
            else if ([[key1 description] compare:[key2 description]] == NSOrderedDescending) {
                return NSOrderedDescending;
            }
            else {
                return NSOrderedSame;
            }
        }];
        NSUInteger numberOfAllKeys = [allKeys count];
        for (NSUInteger i = 0; i < numberOfAllKeys; i++) {
            id key = allKeys[i];
            traverse_object(stringM, key, depth + 1, NO);
            
            id value = [object objectForKey:key];
            traverse_object(stringM, value, depth + 1, YES);
            
            // newline after one pair except last one
            [stringM appendString:(i != numberOfAllKeys - 1 ? @",\n" : @"")];
        }
        
        // revert the process of @"{"
        [stringM appendString:@"\n"];
        // handle indentation
        for (NSUInteger i = 0; i < depth; i++) {
            [stringM appendString:INDENTATION];
        }
        [stringM appendString:@"}"];
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        [stringM appendString:@"[\n"];
        
        NSUInteger numberOfAllItems = [object count];
        for (NSUInteger i = 0; i < numberOfAllItems; i++) {
            id item = object[i];
            traverse_object(stringM, item, depth + 1, NO);
            
            // newline after one item except last one
            [stringM appendString:(i != numberOfAllItems - 1 ? @",\n" : @"")];
        }
        
        // revert the process of @"["
        [stringM appendString:@"\n"];
        // handle indentation
        for (NSUInteger i = 0; i < depth; i++) {
            [stringM appendString:INDENTATION];
        }
        [stringM appendString:@"]"];
    }
    else if ([object isKindOfClass:[NSString class]]) {
        NSString *JSONEscapedString = JSONEscapedStringFromString((NSString *)object);
        [stringM appendFormat:@"\"%@\"", JSONEscapedString];
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        
        // @sa http://stackoverflow.com/questions/2518761/get-type-of-nsnumber
        if (object == (void *)kCFBooleanTrue || object == (void *)kCFBooleanFalse) {
            // only convert @YES/@NO to true/false, not support @(true)/@(TRUE)
            BOOL isTrue = [object boolValue];
            [stringM appendString:(isTrue ? @"true" : @"false")];
        }
        else {
            [stringM appendFormat:@"%@", [object stringValue]];
        }
    }
    else if ([object isKindOfClass:[NSNull class]]) {
        [stringM appendString:@"null"];
    }
    else {
        // call object's description method
        [stringM appendFormat:@"%@", object];
    }
}

// Convert NSString to JSON string
static NSString * JSONEscapedStringFromString(NSString *string) {
    NSMutableString *stringM = [NSMutableString stringWithString:string];
    
    [stringM replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    
    return [NSString stringWithString:stringM];
}

#pragma mark ::

#pragma mark - Runtime

#pragma mark > Class

+ (NSArray<NSString *> *)allClasses {
    unsigned int classesCount;
    Class *classes = objc_copyClassList(&classesCount);
    NSMutableArray *result = [NSMutableArray array];
    for (unsigned int i = 0 ; i < classesCount; i++) {
        [result addObject:NSStringFromClass(classes[i])];
    }
    return [result sortedArrayUsingSelector:@selector(compare:)];
}


#pragma mark > Property

+ (nullable NSArray<NSString *> *)propertiesWithClass:(Class)clz {
    if (clz == nil) {
        return nil;
    }
    
    unsigned int outCount;
    objc_property_t *properties = class_copyPropertyList(clz, &outCount);
    NSMutableArray<NSString *> *result = [NSMutableArray array];
    for (unsigned int i = 0; i < outCount; i++) {
        [result addObject:[self formattedPropery:properties[i]]];
    }
    free(properties);
    
    return result.count ? [result copy] : nil;
}

+ (nullable NSArray<NSString *> *)propertiesWithInstance:(id)instance {
    return [self propertiesWithClass:[instance class]];
}

#pragma mark ::

+ (NSString *)formattedPropery:(objc_property_t)prop {
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(prop, &attrCount);
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    for (unsigned int idx = 0; idx < attrCount; idx++) {
        NSString *name = [NSString stringWithCString:attrs[idx].name encoding:NSUTF8StringEncoding];
        NSString *value = [NSString stringWithCString:attrs[idx].value encoding:NSUTF8StringEncoding];
        [attributes setObject:value forKey:name];
    }
    free(attrs);
    
    NSMutableString *propertyString = [NSMutableString stringWithFormat:@"@property "];
    NSMutableArray *attrsArray = [NSMutableArray array];
    
    //https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html#//apple_ref/doc/uid/TP40008048-CH101-SW5
    [attrsArray addObject:[attributes objectForKey:@"N"] ? @"nonatomic" : @"atomic"];
    
    if ([attributes objectForKey:@"&"]) {
        [attrsArray addObject:@"strong"];
    }
    else if ([attributes objectForKey:@"C"]) {
        [attrsArray addObject:@"copy"];
    }
    else if ([attributes objectForKey:@"W"]) {
        [attrsArray addObject:@"weak"];
    }
    else {
        [attrsArray addObject:@"assign"];
    }
    
    if ([attributes objectForKey:@"R"]) {
        [attrsArray addObject:@"readonly"];
    }
    
    if ([attributes objectForKey:@"G"]) {
        [attrsArray addObject:[NSString stringWithFormat:@"getter=%@", [attributes objectForKey:@"G"]]];
    }
    
    if ([attributes objectForKey:@"S"]) {
        [attrsArray addObject:[NSString stringWithFormat:@"setter=%@", [attributes objectForKey:@"G"]]];
    }
    
    [propertyString appendFormat:@"(%@) %@ %@", [attrsArray componentsJoinedByString:@", "], [self decodeType:[[attributes objectForKey:@"T"] cStringUsingEncoding:NSUTF8StringEncoding]], [NSString stringWithCString:property_getName(prop) encoding:NSUTF8StringEncoding]];
    
    return [propertyString copy];
}

#pragma mark ::

#pragma mark > Ivar

+ (nullable NSArray<NSString *> *)ivarsWithClass:(Class)clz {
    if (clz == nil) {
        return nil;
    }
    
    unsigned int outCount;
    Ivar *ivars = class_copyIvarList(clz, &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (unsigned int i = 0; i < outCount; i++) {
        NSString *type = [self decodeType:ivar_getTypeEncoding(ivars[i])];
        NSString *name = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSUTF8StringEncoding];
        NSString *ivarDescription = [NSString stringWithFormat:@"%@ %@", type, name];
        [result addObject:ivarDescription];
    }
    free(ivars);
    
    return result.count ? [result copy] : nil;
}

+ (nullable NSArray<NSString *> *)ivarsWithInstance:(id)instance {
    return [self ivarsWithClass:[instance class]];
}

#pragma mark - Utility

//https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
+ (NSString *)decodeType:(const char *)cString {
    if (!strcmp(cString, @encode(id))) return @"id";
    if (!strcmp(cString, @encode(void))) return @"void";
    if (!strcmp(cString, @encode(float))) return @"float";
    if (!strcmp(cString, @encode(int))) return @"int";
    if (!strcmp(cString, @encode(BOOL))) return @"BOOL";
    if (!strcmp(cString, @encode(char *))) return @"char *";
    if (!strcmp(cString, @encode(double))) return @"double";
    if (!strcmp(cString, @encode(Class))) return @"class";
    if (!strcmp(cString, @encode(SEL))) return @"SEL";
    if (!strcmp(cString, @encode(unsigned int))) return @"unsigned int";
    if (!strcmp(cString, @encode(unsigned long))) return @"unsigned long"; // "Q"
    
    //@TODO: do handle bitmasks
    NSString *result = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
    if ([[result substringToIndex:1] isEqualToString:@"@"] && [result rangeOfString:@"?"].location == NSNotFound) {
        result = [[result substringWithRange:NSMakeRange(2, result.length - 3)] stringByAppendingString:@"*"];
    }
    else {
        if ([[result substringToIndex:1] isEqualToString:@"^"]) {
            result = [NSString stringWithFormat:@"%@ *", [self decodeType:[[result substringFromIndex:1] cStringUsingEncoding:NSUTF8StringEncoding]]];
        }
    }
    return result;
}

@end
