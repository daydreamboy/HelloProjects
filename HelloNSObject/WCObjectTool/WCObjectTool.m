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

+ (nullable id)dumpedJSONObjectWithObject:(id)object {
    if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]] || object == [NSNull null]) {
        return object;
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (id element in (NSArray *)object) {
            id item = [self dumpedJSONObjectWithObject:element];
            if (item) {
                [arrM addObject:item];
            }
        }
        return arrM;
    }
    else if ([object isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        [(NSDictionary *)object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isKindOfClass:[NSString class]]) {
                id value = [self dumpedJSONObjectWithObject:obj];
                if (value) {
                    dictM[key] = value;
                }
            }
        }];
        return dictM;
    }
    else {
        return [NSString stringWithFormat:@"<%@: %p>", NSStringFromClass([object class]), object];
    }
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
    unsigned int outCount;
    Class *classes = objc_copyClassList(&outCount);
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:(NSUInteger)outCount];
    for (unsigned int i = 0 ; i < outCount; i++) {
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
    
    [result sortUsingSelector:@selector(compare:)];
    
    return result.count ? [result copy] : nil;
}

+ (nullable NSArray<NSString *> *)propertiesWithInstance:(id)instance {
    return [self propertiesWithClass:[instance class]];
}

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
    
    [result sortUsingSelector:@selector(compare:)];
    
    return result.count ? [result copy] : nil;
}

+ (nullable NSArray<NSString *> *)ivarsWithInstance:(id)instance {
    return [self ivarsWithClass:[instance class]];
}

#pragma mark > Class Method

+ (nullable NSArray<NSString *> *)classMethodsWithClass:(Class)clz {
    return [self methodsForClass:object_getClass(clz) typeFormat:@"+"];
}

+ (nullable NSArray<NSString *> *)classMethodsWithInstance:(id)instance {
    return [self classMethodsWithClass:[instance class]];
}

#pragma mark > Instance Method

+ (nullable NSArray<NSString *> *)instanceMethodsWithClass:(Class)clz {
    return [self methodsForClass:clz typeFormat:@"-"];
}

+ (nullable NSArray<NSString *> *)instanceMethodsWithInstance:(id)instance {
    return [self instanceMethodsWithClass:[instance class]];
}

#pragma mark > Protocol

+ (nullable NSArray<NSString *> *)protocolsWithClass:(Class)clz {
    if (clz == nil) {
        return nil;
    }
    
    unsigned int outCount;
    Protocol * const *protocols = class_copyProtocolList(clz, &outCount);
    
    NSMutableArray *result = [NSMutableArray array];
    for (unsigned int i = 0; i < outCount; i++) {
        unsigned int adoptedCount;
        Protocol * const *adoptedProtocols = protocol_copyProtocolList(protocols[i], &adoptedCount);
        NSString *protocolName = [NSString stringWithCString:protocol_getName(protocols[i]) encoding:NSUTF8StringEncoding];
        
        NSMutableArray *adoptedProtocolNames = [NSMutableArray array];
        for (unsigned int idx = 0; idx < adoptedCount; idx++) {
            [adoptedProtocolNames addObject:[NSString stringWithCString:protocol_getName(adoptedProtocols[idx]) encoding:NSUTF8StringEncoding]];
        }
        NSString *protocolDescription = protocolName;
        
        if (adoptedProtocolNames.count) {
            protocolDescription = [NSString stringWithFormat:@"%@ <%@>", protocolName, [adoptedProtocolNames componentsJoinedByString:@", "]];
        }
        [result addObject:protocolDescription];
        free((void *)adoptedProtocols);
    }
    free((void *)protocols);
    [result sortUsingSelector:@selector(compare:)];
    
    return result.count ? [result copy] : nil;
}

+ (nullable NSArray<NSString *> *)protocolsWithInstance:(id)instance {
    return [self protocolsWithClass:[instance class]];
}

+ (nullable NSDictionary<NSString *, NSArray *> *)descriptionForProtocolName:(NSString *)protocolName {
    return [self descriptionForProtocol:NSProtocolFromString(protocolName)];
}

+ (nullable NSDictionary<NSString *, NSArray *> *)descriptionForProtocol:(Protocol *)protocol {
    if (protocol == NULL) {
        return nil;
    }
    
    NSMutableDictionary *methodsAndProperties = [NSMutableDictionary dictionary];
    
    NSArray *requiredMethods = [[[self class] formattedMethodsForProtocol:protocol required:YES instance:NO] arrayByAddingObjectsFromArray:[[self class]formattedMethodsForProtocol:protocol required:YES instance:YES]];
    
    NSArray *optionalMethods = [[[self class] formattedMethodsForProtocol:protocol required:NO instance:NO] arrayByAddingObjectsFromArray:[[self class]formattedMethodsForProtocol:protocol required:NO instance:YES]];

    unsigned int propertiesCount;
    NSMutableArray *propertyDescriptions = [NSMutableArray array];
    objc_property_t *properties = protocol_copyPropertyList(protocol, &propertiesCount);
    for (unsigned int i = 0; i < propertiesCount; i++) {
        [propertyDescriptions addObject:[self formattedPropery:properties[i]]];
    }
    
    if (requiredMethods.count) {
        [methodsAndProperties setObject:requiredMethods forKey:@"@required"];
    }
    if (optionalMethods.count) {
        [methodsAndProperties setObject:optionalMethods forKey:@"@optional"];
    } if (propertyDescriptions.count) {
        [methodsAndProperties setObject:[propertyDescriptions copy] forKey:@"@properties"];
    }
    
    free(properties);
    return methodsAndProperties.count ? [methodsAndProperties copy ] : nil;
}

#pragma mark > Class Hierarchy

+ (nullable NSArray<NSString *> *)classHierarchyWithClass:(Class)clz {
    if (clz == NULL) {
        return nil;
    }
    
    NSMutableArray<NSString *> *classNames = [NSMutableArray arrayWithCapacity:10];
    getSuper(clz, classNames);
    
    return classNames;
}

+ (nullable NSArray<NSString *> *)classHierarchyWithInstance:(id)instance {
    return [self classHierarchyWithClass:[instance class]];
}

+ (nullable NSString *)printClassHierarchyWithClass:(Class)clz {
    if (clz == NULL) {
        return nil;
    }
    
    NSArray<NSString *> *classNames = [self classHierarchyWithClass:clz];
    return [classNames componentsJoinedByString:@" -> "];
}

+ (nullable NSString *)printClassHierarchyWithInstance:(id)instance {
    return [self printClassHierarchyWithClass:[instance class]];
}

#pragma mark ::

static void getSuper(Class class, NSMutableArray *result) {
    if (class != NULL) {
        [result addObject:NSStringFromClass(class)];
        if ([class superclass]) { getSuper([class superclass], result); }
    }
}

#pragma mark ::

+ (BOOL)checkIfObject:(id)object overridesSelector:(SEL)selector {
    return [self checkIfSubclass:[object class] overridesSelector:selector];
}

+ (BOOL)checkIfSubclass:(Class)subclass overridesSelector:(SEL)selector {
    Class superClass = class_getSuperclass(subclass);
    
    BOOL isMethodOverridden = NO;
    
    while (superClass != Nil) {
        isMethodOverridden = [superClass instancesRespondToSelector:selector] && ([subclass instanceMethodForSelector:selector] != [superClass instanceMethodForSelector:selector]);
        
        if (isMethodOverridden) {
            break;
        }
        
        superClass = [superClass superclass];
    }
    
    return isMethodOverridden;
}

#pragma mark - Utility

//https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
+ (NSString *)decodeType:(const char *)cString {
    if (!strcmp(cString, @encode(id))) return @"id"; // "@"
    if (!strcmp(cString, @encode(void))) return @"void";
    if (!strcmp(cString, @encode(BOOL))) return @"BOOL";
    if (!strcmp(cString, @encode(float))) return @"float";
    if (!strcmp(cString, @encode(double))) return @"double";
    if (!strcmp(cString, @encode(Class))) return @"class"; // "#"
    if (!strcmp(cString, @encode(SEL))) return @"SEL"; // ":"
    
    if (!strcmp(cString, @encode(char))) return @"char"; // "c"
    if (!strcmp(cString, @encode(short))) return @"short"; // "s"
    if (!strcmp(cString, @encode(int))) return @"int"; // "i"
    if (!strcmp(cString, @encode(long))) return @"long"; // "q"
    
    if (!strcmp(cString, @encode(unsigned char))) return @"unsigned char"; // "C"
    if (!strcmp(cString, @encode(unsigned short))) return @"unsigned short"; // "S"
    if (!strcmp(cString, @encode(unsigned int))) return @"unsigned int"; // "I"
    if (!strcmp(cString, @encode(unsigned long))) return @"unsigned long"; // "Q"
    
    if (!strcmp(cString, @encode(long double))) return @"long double"; // "D"
    
    if (!strcmp(cString, @encode(char *))) return @"char *"; // "^c"
    if (!strcmp(cString, @encode(void *))) return @"void *"; // "^v"
    if (!strcmp(cString, @encode(int *))) return @"int *"; // "^i"
    if (!strcmp(cString, @encode(long *))) return @"long *"; // "^q"
    if (!strcmp(cString, @encode(float *))) return @"float *"; // "^f"
    if (!strcmp(cString, @encode(double *))) return @"double *"; // "^d"
    if (!strcmp(cString, @encode(BOOL *))) return @"BOOL *"; // "^B"
    
    if (!strcmp(cString, @encode(const char *))) return @"const char *"; // "r*"
    
    // function pointer, e.g. IMP, char (*)(long), ....
    if (!strcmp(cString, @encode(IMP))) return @"IMP"; // "^?"
    
    // block, e.g. dispatch_block_t, void (^)(void), ...
    if (!strcmp(cString, @encode(dispatch_block_t))) return @"dispatch_block_t"; // "@?"
    
    
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

+ (nullable NSArray *)methodsForClass:(Class)clz typeFormat:(NSString *)type {
    if (clz == nil) {
        return nil;
    }
    
    unsigned int outCount;
    Method *methods = class_copyMethodList(clz, &outCount);
    NSMutableArray *result = [NSMutableArray array];
    for (unsigned int i = 0; i < outCount; i++) {
        NSString *methodDescription = [NSString stringWithFormat:@"%@ (%@)%@",
                                       type,
                                       [self decodeType:method_copyReturnType(methods[i])],
                                       NSStringFromSelector(method_getName(methods[i]))];
        
        NSInteger args = method_getNumberOfArguments(methods[i]);
        NSMutableArray *selParts = [[methodDescription componentsSeparatedByString:@":"] mutableCopy];
        NSInteger offset = 2; //1-st arg is object (@), 2-nd is SEL (:)
        
        for (NSInteger idx = offset; idx < args; idx++) {
            NSString *returnType = [self decodeType:method_copyArgumentType(methods[i], (unsigned int)idx)];
            selParts[idx - offset] = [NSString stringWithFormat:@"%@:(%@)arg%d",
                                      selParts[idx - offset],
                                      returnType,
                                      (int)(idx - 2)];
        }
        [result addObject:[selParts componentsJoinedByString:@" "]];
    }
    free(methods);
    
    [result sortUsingSelector:@selector(compare:)];
    
    return result.count ? [result copy] : nil;
}

+ (NSString *)formattedPropery:(objc_property_t)property {
    unsigned int attrCount;
    objc_property_attribute_t *attrs = property_copyAttributeList(property, &attrCount);
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
    
    [propertyString appendFormat:@"(%@) %@ %@", [attrsArray componentsJoinedByString:@", "], [self decodeType:[[attributes objectForKey:@"T"] cStringUsingEncoding:NSUTF8StringEncoding]], [NSString stringWithCString:property_getName(property) encoding:NSUTF8StringEncoding]];
    
    return [propertyString copy];
}

+ (NSArray *)formattedMethodsForProtocol:(Protocol *)protocol required:(BOOL)required instance:(BOOL)instance {
    unsigned int methodCount;
    struct objc_method_description *methods = protocol_copyMethodDescriptionList(protocol, required, instance, &methodCount);
    NSMutableArray *methodsDescription = [NSMutableArray array];
    for (unsigned int i = 0; i < methodCount; i++) {
        [methodsDescription addObject:
         [NSString stringWithFormat:@"%@ (%@)%@",
          instance ? @"-" : @"+",
#warning return correct type
          // TODO: return correct type
          @"void",
          NSStringFromSelector(methods[i].name)]];
    }
    
    free(methods);
    return  [methodsDescription copy];
}

@end
