//
//  WCJSONTool.m
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCJSONTool.h"
#import <objc/runtime.h>

#define NSPREDICATE(expression)    ([NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression])

// >= `11.0`
#ifndef IOS11_OR_LATER
#define IOS11_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"11.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCJSONTool

#pragma mark - Object to String

+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options {
    return [self JSONStringWithObject:object printOptions:options filterInvalidObjects:NO];
}

+ (nullable NSString *)JSONStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options filterInvalidObjects:(BOOL)filterInvalidObjects {
    if (![object isKindOfClass:[NSObject class]]) {
        return nil;
    }
    
    id rootObject = object;
    if ([rootObject isKindOfClass:[NSString class]]) {
        return (NSString *)rootObject;
    }
    else if ([rootObject isKindOfClass:[NSNumber class]] || [rootObject isKindOfClass:[NSNull class]]) {
        NSData *jsonData = nil;
        NSError *error = nil;
        @try {
            // @see https://stackoverflow.com/a/34268973
            // convert to array for distinguish @1/@YES, @0/@NO
            jsonData = [NSJSONSerialization dataWithJSONObject:@[rootObject] options:options error:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass(self), exception);
        }
        
        NSString *jsonString = nil;
        if (jsonData && !error) {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            // Note: remove [] to get the only one element
            jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
        }
        
        return jsonString;
    }
    else if ([rootObject isKindOfClass:[NSArray class]] || [rootObject isKindOfClass:[NSDictionary class]]) {
        if (filterInvalidObjects && ![NSJSONSerialization isValidJSONObject:rootObject]) {
            rootObject = [self safeJSONObjectWithObject:rootObject];
        }
        
        NSData *jsonData = nil;
        NSError *error = nil;
        @try {
            jsonData = [NSJSONSerialization dataWithJSONObject:rootObject options:options error:&error];
        }
        @catch (NSException *exception) {
            NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass(self), exception);
        }
        
        NSString *jsonString = nil;
        if (jsonData && !error) {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        return jsonString;
    }
    else {
        return nil;
    }
}

+ (nullable NSString *)JSONStringWithKVCObject:(id)KVCObject printOptions:(NSJSONWritingOptions)options keyTreeDescription:(id)keyTreeDescription {
    if (![KVCObject isKindOfClass:[NSObject class]]) {
        return nil;
    }
    
    if (![keyTreeDescription isKindOfClass:[NSString class]] && ![keyTreeDescription isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSDictionary *walkTree = nil;
    if ([keyTreeDescription isKindOfClass:[NSString class]] && [(NSString *)keyTreeDescription length]) {
        walkTree = [self JSONDictWithString:keyTreeDescription allowMutable:NO];
    }
    else if ([keyTreeDescription isKindOfClass:[NSDictionary class]] && [(NSDictionary *)keyTreeDescription count]) {
        walkTree = keyTreeDescription;
    }
    
    if (!walkTree) {
        return nil;
    }
    
    
    NSDictionary *JSONDict = [self searchPropertiesWithKVCObject:KVCObject keyTreeDescription:walkTree];
    if (!JSONDict) {
        return nil;
    }
    
    return [self JSONStringWithObject:JSONDict printOptions:options];
}

#pragma mark ::

+ (nullable NSMutableDictionary *)searchPropertiesWithKVCObject:(NSObject *)KVCObject keyTreeDescription:(NSDictionary *)keyTreeDescription {
    NSMutableDictionary *containerDict = [NSMutableDictionary dictionary];
    
    for (NSString *currentKey in keyTreeDescription) {
        if ([currentKey isKindOfClass:[NSString class]] && currentKey.length) {
            id currentValue = nil;
            @try {
                currentValue = [KVCObject valueForKey:currentKey];
            } @catch (NSException *exception) {}
            
            id innerKeys = keyTreeDescription[currentKey];
            
            if ([innerKeys isKindOfClass:[NSDictionary class]] && ((NSDictionary *)innerKeys).count) {
                // currentValue is NSDictionary or KVC Object
                id value = [self searchPropertiesWithKVCObject:currentValue keyTreeDescription:innerKeys];
                if (value) {
                    containerDict[currentKey] = value;
                }
            }
            else if ([innerKeys isKindOfClass:[NSArray class]] && ((NSArray *)innerKeys).count) {
                // currentValue is NSArray
                if ([currentValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *containerArr = [NSMutableArray arrayWithCapacity:((NSArray *)currentValue).count];
                    NSArray *arr = (NSArray *)currentValue;
                    
                    for (NSUInteger i = 0; i < arr.count; ++i) {
                        NSUInteger index = i > ((NSArray *)innerKeys).count - 1 ? ((NSArray *)innerKeys).count - 1 : i;
                        id innerKeysForItem = innerKeys[index];
                        
                        if ([innerKeysForItem isKindOfClass:[NSDictionary class]]) {
                            id item = arr[i];
                            id value = [self searchPropertiesWithKVCObject:item keyTreeDescription:innerKeysForItem];
                            if (value) {
                                [containerArr addObject:value];
                            }
                        }
                    }
                    
                    if (containerArr.count) {
                        containerDict[currentKey] = containerArr;
                    }
                }
            }
            else {
                if (currentValue) {
                    containerDict[currentKey] = currentValue;
                }
            }
        }
    }
    
    return containerDict.count ? containerDict : nil;
}

#pragma mark ::

#pragma mark - String to Object

#pragma mark > to NSDictionary/NSArray

+ (nullable NSArray *)JSONArrayWithString:(NSString *)string allowMutable:(BOOL)allowMutable {
    return [self JSONObjectWithString:string options:(allowMutable ? NSJSONReadingMutableContainers : kNilOptions) objectClass:(allowMutable ? [NSMutableArray class] : [NSArray class])];
}

+ (nullable NSDictionary *)JSONDictWithString:(NSString *)string allowMutable:(BOOL)allowMutable {
    return [self JSONObjectWithString:string options:(allowMutable ? NSJSONReadingMutableContainers : kNilOptions) objectClass:(allowMutable ? [NSMutableDictionary class] : [NSDictionary class])];
}

#pragma mark > to id

+ (nullable id)JSONObjectWithString:(NSString *)string options:(NSJSONReadingOptions)options objectClass:(nullable Class)objectClass {
    if (![string isKindOfClass:[NSString class]] || string.length == 0) {
        return nil;
    }
    
    // @see https://stackoverflow.com/a/11192483
    NSCharacterSet *controlCharsterSet = [NSCharacterSet controlCharacterSet];
    NSRange range = [string rangeOfCharacterFromSet:controlCharsterSet];
    if (range.location != NSNotFound) {
        NSMutableString *stringM = [NSMutableString stringWithString:string];
        while (range.location != NSNotFound) {
            [stringM deleteCharactersInRange:range];
            range = [stringM rangeOfCharacterFromSet:controlCharsterSet];
        }
        return [self JSONObjectWithData:[stringM dataUsingEncoding:NSUTF8StringEncoding] options:options objectClass:objectClass];;
    }
    
    return [self JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:options objectClass:objectClass];
}

#pragma mark > to model

+ (nullable id)JSONModelWithString:(NSString *)string modelClassMapping:(NSDictionary<NSString *, Class> *)modelClassMapping JSONKeysToModelKeys:(nullable NSDictionary *)JSONKeysToModelKeys {
    if (![string isKindOfClass:[NSString class]] || ![modelClassMapping isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if ([string isKindOfClass:[NSString class]] && string.length == 0) {
        return nil;
    }
    
    if (JSONKeysToModelKeys && ![JSONKeysToModelKeys isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    id JSONObject = [self JSONObjectWithString:string options:kNilOptions objectClass:nil];
    
    if ([JSONObject isKindOfClass:[NSArray class]] || [JSONObject isKindOfClass:[NSDictionary class]]) {
        if ([modelClassMapping isKindOfClass:[NSDictionary class]] && modelClassMapping[@"_root"] == nil) {
            return nil;
        }
    }

    return [self safeJSONModelWithJSONObject:JSONObject rootModelKey:@"_root" modelClassMapping:modelClassMapping JSONKeysToModelKeys:JSONKeysToModelKeys];
}

#pragma mark ::

+ (nullable id)safeJSONModelWithJSONObject:(id)JSONObject rootModelKey:(NSString *)rootKey modelClassMapping:(NSDictionary<NSString *, Class> *)modelClassMapping JSONKeysToModelKeys:(nullable NSDictionary *)JSONKeysToModelKeys {
    if ([JSONObject isKindOfClass:[NSNumber class]] || [JSONObject isKindOfClass:[NSString class]] || JSONObject == [NSNull null]) {
        return JSONObject;
    }
    else if ([JSONObject isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (id element in (NSArray *)JSONObject) {
            id item = [self safeJSONModelWithJSONObject:element rootModelKey:rootKey modelClassMapping:modelClassMapping JSONKeysToModelKeys:JSONKeysToModelKeys];
            if (item) {
                [arrM addObject:item];
            }
        }
        return arrM;
    }
    else if ([JSONObject isKindOfClass:[NSDictionary class]]) {
        Class modelClass = modelClassMapping[rootKey];
        NSObject<WCJSONModel> *model = [[modelClass alloc] init];
        if ([model respondsToSelector:@selector(JSONModelClassDidInit:JSONKey:)]) {
            [model JSONModelClassDidInit:model JSONKey:rootKey];
        }
        
        if (model) {
            [(NSDictionary *)JSONObject enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isKindOfClass:[NSString class]]) {
                    id value = [self safeJSONModelWithJSONObject:obj rootModelKey:key modelClassMapping:modelClassMapping JSONKeysToModelKeys:JSONKeysToModelKeys];
                    if (value) {
                        @try {
                            NSString *modelKey = key;
                            
                            if (JSONKeysToModelKeys[key]) {
                                modelKey = JSONKeysToModelKeys[key];
                            }
                            
                            // @see https://stackoverflow.com/questions/25213707/parsing-json-to-a-predefined-class-in-objective-c
                            [model setValue:value forKey:modelKey];
                            
                            if ([model respondsToSelector:@selector(JSONModelClassDidSetValueForKey:modelKey:JSONKey:value:)]) {
                                [model JSONModelClassDidSetValueForKey:model modelKey:modelKey JSONKey:key value:value];
                            }
                        }
                        @catch (NSException *exception) {
                            NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass([self class]), exception);
                        }
                    }
                }
            }];
        }
        
        return model;
    }
    else {
        return nil;
    }
}

#pragma mark ::

#pragma mark - Data to Object

#pragma mark > to NSDictionary/NSArray

+ (nullable NSDictionary *)JSONDictWithData:(NSData *)data allowMutable:(BOOL)allowMutable {
    if (allowMutable) {
        return [self JSONObjectWithData:data options:NSJSONReadingMutableContainers objectClass:[NSMutableDictionary class]];
    }
    else {
        return [self JSONObjectWithData:data options:kNilOptions objectClass:[NSDictionary class]];
    }
}

+ (nullable NSArray *)JSONArrayWithData:(NSData *)data allowMutable:(BOOL)allowMutable {
    if (allowMutable) {
        return [self JSONObjectWithData:data options:NSJSONReadingMutableContainers objectClass:[NSMutableArray class]];
    }
    else {
        return [self JSONObjectWithData:data options:kNilOptions objectClass:[NSArray class]];
    }
}

#pragma mark > to id

+ (nullable id)JSONObjectWithData:(NSData *)data options:(NSJSONReadingOptions)options objectClass:(nullable Class)objectClass {
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    if (objectClass &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSArray class])] &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSMutableArray class])] &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSDictionary class])] &&
        ![NSStringFromClass(objectClass) isEqualToString:NSStringFromClass([NSMutableDictionary class])]
        ) {
        return nil;
    }
    
    @try {
        NSError *error;
        id JSONObject = [NSJSONSerialization JSONObjectWithData:data options:options error:&error];
        if (!JSONObject) {
            NSLog(@"[%@] error parsing JSON: %@", NSStringFromClass([self class]), error);
        }
        
        if (objectClass == nil) {
            return JSONObject;
        }
        else {
            if ([JSONObject isKindOfClass:objectClass]) {
                return JSONObject;
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass([self class]), exception);
    }
    
    return nil;
}

#pragma mark - JSON Escaped String

+ (nullable NSString *)JSONEscapedStringWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
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

+ (nullable NSString *)escapedJSONStringWithJSONString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (string.length == 0) {
        return string;
    }
    
    NSDictionary *container = @{@"key": string};
    NSError *error = nil;
    
    NSData *JSONData = [NSJSONSerialization dataWithJSONObject:container options:kNilOptions error:&error];
    NSString *JSONString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    NSMutableString *JSONStringM = [NSMutableString stringWithString:JSONString];
    
    [JSONStringM deleteCharactersInRange:NSMakeRange(JSONString.length - 1, @"}".length)];
    [JSONStringM deleteCharactersInRange:NSMakeRange(0, @"{\"key\":".length)];
    
    return [JSONStringM copy];
}

#pragma mark - Assistant Methods

#pragma mark > Safe JSON Object

+ (nullable id)safeJSONObjectWithObject:(id)object {
    if ([object isKindOfClass:[NSNumber class]] || [object isKindOfClass:[NSString class]] || object == [NSNull null]) {
        return object;
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (id element in (NSArray *)object) {
            id item = [self safeJSONObjectWithObject:element];
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
                id value = [self safeJSONObjectWithObject:obj];
                if (value) {
                    dictM[key] = value;
                }
            }
        }];
        return dictM;
    }
    else {
        return nil;
    }
}

#pragma mark > JSON Object Mutable Copy

+ (nullable id)mutableCopiedJSONObjectWithObject:(id)object allowKVCObjects:(BOOL)allowKVCObjects allowMutableLeaves:(BOOL)allowMutableLeaves {
    if (object == [NSNull null]) {
        return object;
    }
    else if ([object isKindOfClass:[NSNumber class]]) {
        // Note: NSNumber is immutable, not support copying
        // @see https://stackoverflow.com/questions/6099667/nsnumbers-copy-is-not-allocating-new-memory/6099711
        return object;
    }
    else if ([object isKindOfClass:[NSString class]]) {
        return allowMutableLeaves ? [object mutableCopy] : object;
    }
    else if ([object isKindOfClass:[NSArray class]]) {
        NSMutableArray *arrM = [NSMutableArray array];
        for (id element in (NSArray *)object) {
            id item = [self mutableCopiedJSONObjectWithObject:element allowKVCObjects:allowKVCObjects allowMutableLeaves:allowMutableLeaves];
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
                id value = [self mutableCopiedJSONObjectWithObject:obj allowKVCObjects:allowKVCObjects allowMutableLeaves:allowMutableLeaves];
                if (value) {
                    dictM[key] = value;
                }
            }
        }];
        return dictM;
    }
    else if (allowKVCObjects && [object isKindOfClass:[NSObject class]] && [object respondsToSelector:@selector(mutableCopy)]) {
        return [object mutableCopy];
    }
    else {
        return nil;
    }
}

#pragma mark > Merge two JSON Objects

+ (nullable id)mergeToJSONObject:(id)toJSONObject fromJSONObject:(nullable id)fromJSONObject mergeMode:(WCJSONToolMergeMode)mergeMode {
    // toJSONObject expected not nil and must be JSON object
    if (!toJSONObject || ![NSJSONSerialization isValidJSONObject:toJSONObject]) {
        return nil;
    }
    
    // fromJSONObject allow nil and not be JSON object
    if (!fromJSONObject || ![NSJSONSerialization isValidJSONObject:fromJSONObject]) {
        return toJSONObject;
    }
    
    return [self mergeTwoJSONObjectWithBaseObject:toJSONObject additionalObject:fromJSONObject mergeMode:mergeMode];
}

+ (nullable id)mergeTwoJSONObjectWithBaseObject:(id)baseObject additionalObject:(nullable id)additionalObject mergeMode:(WCJSONToolMergeMode)mergeMode {
    // null not replace
    if (baseObject == [NSNull null]) {
        return baseObject;
    }
    else if ([baseObject isKindOfClass:[NSNumber class]]) {
        return [additionalObject isKindOfClass:[NSNumber class]] ? additionalObject : baseObject;
    }
    else if ([baseObject isKindOfClass:[NSString class]]) {
        return [additionalObject isKindOfClass:[NSString class]] ? additionalObject : baseObject;
    }
    else if ([baseObject isKindOfClass:[NSArray class]]) {
        if (![additionalObject isKindOfClass:[NSArray class]]) {
            return baseObject;
        }
        
        NSArray *baseObjectArray = (NSArray *)baseObject;
        NSArray *additionalObjectArray = (NSArray *)additionalObject;
        
        // additionalObjectArray's count not match baseObjectArray's count, use baseObjectArray
        if (baseObjectArray.count != additionalObjectArray.count) {
            return baseObjectArray;
        }
        
        NSMutableArray *arrM = [NSMutableArray array];
        for (NSUInteger i = 0; i < baseObjectArray.count; ++i) {
            id itemInBaseObjectArray = baseObjectArray[i];
            id itemInAdditionalObjectArray = additionalObjectArray[i];
            
            id mergedItem = [self mergeTwoJSONObjectWithBaseObject:itemInBaseObjectArray additionalObject:itemInAdditionalObjectArray mergeMode:mergeMode];
            if (mergedItem) {
                [arrM addObject:mergedItem];
            }
        }
        return arrM;
    }
    else if ([baseObject isKindOfClass:[NSDictionary class]]) {
        if (![additionalObject isKindOfClass:[NSDictionary class]]) {
            return baseObject;
        }
        
        NSDictionary *baseObjectDict = (NSDictionary *)baseObject;
        NSDictionary *additionalObjectDict = (NSDictionary *)additionalObject;
        
        // additionalObjectDict's count is 0, use baseObjectDict
        if (additionalObjectDict.count == 0) {
            return baseObjectDict;
        }
        
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        NSMutableSet *commonKeys = [NSMutableSet set];
        
        [baseObjectDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isKindOfClass:[NSString class]]) {
                id itemInBaseObjectDict = obj;
                id itemInAdditionalObjectDict = additionalObjectDict[key];
                
                if (itemInAdditionalObjectDict) {
                    [commonKeys addObject:key];
                }
                
                id mergedItem = [self mergeTwoJSONObjectWithBaseObject:itemInBaseObjectDict additionalObject:itemInAdditionalObjectDict mergeMode:mergeMode];
                if (mergedItem) {
                    dictM[key] = mergedItem;
                }
            }
        }];
        
        
        if (mergeMode == WCJSONToolMergeModeArrayOverwriteMapUnionSet) {
            [additionalObjectDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if (![commonKeys containsObject:key]) {
                    dictM[key] = obj;
                }
            }];
        }
        
        return dictM;
    }
    else {
        return nil;
    }
}

#pragma mark > Key Path Query

#pragma mark >> For JSON Object

+ (nullable NSArray *)arrayOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    return [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:[NSArray class]];
}

+ (nullable NSDictionary *)dictionaryOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    return [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:[NSDictionary class]];
}

+ (nullable NSString *)stringOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    return [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:[NSString class]];
}

+ (NSInteger)integerOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    id obj = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:nil];
    if ([obj isKindOfClass:[NSString class]]) {
        return [obj integerValue];
    }
    else if ([obj isKindOfClass:[NSNumber class]]) {
        return [obj integerValue];
    }
    
    return NSNotFound;
}

+ (nullable NSNumber *)numberOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    return [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:[NSNumber class]];
}

+ (BOOL)boolOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    NSNumber *number = [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:nil];
    if (![number isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    return [number boolValue];
}

+ (nullable NSNull *)nullOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath {
    return [self valueOfJSONObject:JSONObject usingKeyPath:keyPath objectClass:[NSNull class]];
}

+ (nullable id)valueOfJSONObject:(id)JSONObject usingKeyPath:(NSString *)keyPath objectClass:(nullable Class)objectClass {
    // An object that may be converted to JSON must have the following properties:
    // • The top level object is an NSArray or NSDictionary.
    // • All objects are instances of NSString, NSNumber, NSArray, NSDictionary, or NSNull.
    // • All dictionary keys are instances of NSString.
    // • Numbers are not NaN or infinity.
    // @sa https://developer.apple.com/library/ios/documentation/Foundation/Reference/NSJSONSerialization_Class/index.html#//apple_ref/occ/clm/NSJSONSerialization/isValidJSONObject:
    if (JSONObject && ![NSJSONSerialization isValidJSONObject:JSONObject]) {
        return nil;
    }
    
    return [self valueOfKVCObject:JSONObject usingKeyPath:keyPath objectClass:objectClass];
}

+ (id)replaceValueOfKVCObject:(id)JSONObject usingKeyPath:(NSString *)keyPath value:(id)value {
    if (!JSONObject || ![keyPath isKindOfClass:[NSString class]] || !keyPath.length || !value) {
        return nil;
    }
    
    NSArray *parts = [keyPath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".[]"]];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:parts];
    // Note: remove all empty string
    [keys removeObject:@""];
    
    id targetContainer = [self mutableCopiedJSONObjectWithObject:JSONObject allowKVCObjects:YES allowMutableLeaves:NO];
    id currentContainer = targetContainer;
    for (NSUInteger i = 0; i < keys.count; i++) {
        NSString *currentKey = keys[i];
        
        if ([currentContainer isKindOfClass:[NSMutableArray class]]) {
            // Note: handle NSArray container
            if (![NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:currentKey]) {
                NSLog(@"Error: %@ is not a subscript of NSArray", currentKey);
                return nil;
            }
            
            NSInteger index = [currentKey integerValue];
            NSMutableArray *arrM = (NSMutableArray *)currentContainer;
            
            if (index < 0 || index >= arrM.count) {
                NSLog(@"Error: subscript %@ is out of bounds [0..%ld]", currentKey, (long)arrM.count - 1);
                return nil;
            }
            
            if (i == keys.count - 1) {
                arrM[index] = value;
            }
            else {
                currentContainer = arrM[index];
            }
        }
        else if ([currentContainer isKindOfClass:[NSMutableDictionary class]]) {
            // Note: handle NSDictionary container
            NSMutableDictionary *dictM = (NSMutableDictionary *)currentContainer;
            
            if (i == keys.count - 1) {
                dictM[currentKey] = value;
            }
            else {
                currentContainer = dictM[currentKey];
            }
        }
        else if ([currentContainer isKindOfClass:[NSObject class]]) {
            // Note: handle custom container
            NSObject *KVCObject = (NSObject *)currentContainer;
            @try {
                if (i == keys.count - 1) {
                    [KVCObject setValue:value forKey:currentKey];
                }
                else {
                    currentContainer = [KVCObject valueForKey:currentKey];
                }
            }
            @catch (NSException *e) {
                NSLog(@"Error: object %@ is not KVC compliant for key `%@`", KVCObject, currentKey);
                return nil;
            }
        }
        else {
            NSLog(@"Error: unsupported object %@", currentContainer);
            return nil;
        }
    }
    
    return targetContainer;
}

#pragma mark >> For KVC Object

+ (nullable id)valueOfKVCObject:(id)KVCObject usingKeyPath:(NSString *)keyPath objectClass:(nullable Class)objectClass {
    return [self valueOfKVCObject:KVCObject usingKeyPath:keyPath bindings:nil objectClass:objectClass];
}

+ (nullable id)valueOfKVCObject:(id)KVCObject usingKeyPath:(NSString *)keyPath bindings:(nullable NSDictionary *)bindings objectClass:(nullable Class)objectClass {
    if (!KVCObject || ![keyPath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (keyPath.length == 0) {
        return KVCObject;
    }
    
    NSArray *parts = [keyPath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".[]"]];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:parts];
    // Note: remove all empty string
    [keys removeObject:@""];
    
    id value = KVCObject;
    while (keys.count) {
        NSString *key = [keys firstObject];;
        
        if (bindings && [key rangeOfString:@"$"].location != NSNotFound) {
            key = [WCJSONTool stringByReplacingMatchesInString:key pattern:@"\\$(?:\\{([a-zA-Z0-9_-]+)\\}|([a-zA-Z0-9_-]+))" captureGroupBindingBlock:^NSString *(NSString *matchString, NSArray<NSString *> *captureGroupStrings) {
                for (NSString *captureGroupString in captureGroupStrings) {
                    if (bindings[captureGroupString]) {
                        //NSLog(@"Replace %@ to %@", matchString, bindings[captureGroupString]);
                        return bindings[captureGroupString];
                    }
                }
                return nil;
            }];
        }
        
        if ([value isKindOfClass:[NSArray class]]) {
            // Note: handle NSArray container
            if (![NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]) {
                NSLog(@"Error: %@ is not a subscript of NSArray", key);
                return nil;
            }
            
            NSInteger subscript = [key integerValue];
            NSArray *arr = (NSArray *)value;
            
            if (subscript < 0 || subscript >= arr.count) {
                NSLog(@"Error: subscript %@ is out of bounds [0..%ld]", key, (long)arr.count - 1);
                return nil;
            }
            
            value = arr[subscript];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            // Note: handle NSDictionary container
            NSDictionary *dict = (NSDictionary *)value;
            
            value = dict[key];
        }
        else if ([value isKindOfClass:[NSObject class]]) {
            // Note: handle custom container
            NSObject *KVCObject = (NSObject *)value;
            @try {
                value = [KVCObject valueForKey:key];
            }
            @catch (NSException *e) {
                NSLog(@"Error: object %@ is not KVC compliant for key `%@`", KVCObject, key);
                return nil;
            }
        }
        else {
            NSLog(@"Error: unsupported object %@", KVCObject);
            return nil;
        }
        
        [keys removeObjectAtIndex:0];
    }
    
    return (objectClass == nil || [value isKindOfClass:objectClass]) ? value : nil;
}

#pragma mark >> For NSArray/NSDictionary

+ (nullable id)valueOfCollectionObject:(id)collectionObject usingBracketsPath:(NSString *)bracketsPath objectClass:(nullable Class)objectClass {
    if (![bracketsPath isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (!collectionObject || !([collectionObject isKindOfClass:[NSArray class]] || [collectionObject isKindOfClass:[NSDictionary class]])) {
        return nil;
    }
    
    if (bracketsPath.length == 0) {
        return collectionObject;
    }
    
    if (![NSPREDICATE(@"(\\[.+\\])+") evaluateWithObject:bracketsPath]) {
        return nil;
    }
    
    NSArray *parts = [bracketsPath componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]];
    NSMutableArray *keys = [NSMutableArray arrayWithArray:parts];
    // Note: remove all empty string
    [keys removeObject:@""];
    
    id value = collectionObject;
    while (keys.count) {
        NSString *key = [keys firstObject];;
        
        if ([value isKindOfClass:[NSArray class]]) {
            // Note: handle NSArray container
            if (![NSPREDICATE(@"0|[1-9]\\d*") evaluateWithObject:key]) {
                NSLog(@"Error: %@ is not a subscript of NSArray", key);
                return nil;
            }
            
            NSInteger subscript = [key integerValue];
            NSArray *arr = (NSArray *)value;
            
            if (subscript < 0 || subscript >= arr.count) {
                NSLog(@"Error: subscript %@ is out of bounds [0..%ld]", key, (long)arr.count - 1);
                return nil;
            }
            
            value = arr[subscript];
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            if (![NSPREDICATE(@"'.+'") evaluateWithObject:key]) {
                NSLog(@"Error: %@ is not a subscript of NSDictionary, and must be quoted by `'`", key);
                return nil;
            }
            
            // Note: handle NSDictionary container
            NSDictionary *dict = (NSDictionary *)value;
            
            NSString *subscript = [key stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"'"]];
            value = dict[subscript];
        }
        else {
            NSLog(@"Error: get value failed from object %@", collectionObject);
            return nil;
        }
        
        [keys removeObjectAtIndex:0];
    }
    
    return (objectClass == nil || [value isKindOfClass:objectClass]) ? value : nil;
}

#pragma mark > Print JSON string

+ (void)printJSONStringFromJSONObject:(id)JSONObject {
    NSJSONWritingOptions options = NSJSONWritingPrettyPrinted;
    if (IOS11_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability-new"
        options |= NSJSONWritingSortedKeys;
#pragma GCC diagnostic pop
    }
    NSString *JSONString = [self JSONStringWithObject:JSONObject printOptions:options filterInvalidObjects:YES];
    NSLog(@"\n%@\n", JSONString);
}

#pragma mark > Objective-C literal string

+ (nullable NSString *)literalStringWithJSONObject:(id)JSONObject startIndentLength:(NSUInteger)startIndentLength indentLength:(NSUInteger)indentLength ordered:(BOOL)ordered {
    return [self literalStringWithJSONObject:JSONObject indentLevel:0 startIndentLength:startIndentLength indentLength:indentLength ordered:ordered isRootContainer:YES];
}

+ (void)printLiteralStringFromJSONObject:(id)JSONObject {
    NSString *literalString = [self literalStringWithJSONObject:JSONObject startIndentLength:0 indentLength:2 ordered:YES];
    NSLog(@"\n%@\n", literalString);
}

#pragma mark ::

+ (nullable NSString *)literalStringWithJSONObject:(id)JSONObject indentLevel:(NSUInteger)indentLevel startIndentLength:(NSUInteger)startIndentLength indentLength:(NSUInteger)indentLength ordered:(BOOL)ordered isRootContainer:(BOOL)isRootContainer {
    
    if ([JSONObject isKindOfClass:[NSNumber class]]) {
        if ([WCJSONTool checkNumberAsBooleanWithNumber:JSONObject]) {
            return [NSString stringWithFormat:@"%@", [(NSNumber *)JSONObject boolValue] ? @"@YES": @"@NO"];
        }
        else {
            return [NSString stringWithFormat:@"@(%@)", [(NSNumber *)JSONObject stringValue]];
        }
    }
    else if ([JSONObject isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"@\"%@\"", JSONEscapedStringFromString(JSONObject)];
    }
    else if ([JSONObject isKindOfClass:[NSNull class]]) {
        return @"[NSNull null]";
    }
    else if ([JSONObject isKindOfClass:[NSDictionary class]] || [JSONObject isKindOfClass:[NSArray class]]) {
        // @see https://stackoverflow.com/a/4608137
        NSString *indentSpaceForContainer = [@"" stringByPaddingToLength:indentLevel * indentLength + startIndentLength withString:@" " startingAtIndex:0];
        NSString *indentSpaceForElement = [@"" stringByPaddingToLength:(indentLevel + 1) * indentLength + startIndentLength withString:@" " startingAtIndex:0];
        
        NSMutableString *stringM = [NSMutableString stringWithCapacity:1000];
        if (isRootContainer) {
            [stringM appendString:[@"" stringByPaddingToLength:startIndentLength withString:@" " startingAtIndex:0]];
        }
        __block BOOL isFirstElement = YES;
        
        if ([JSONObject isKindOfClass:[NSDictionary class]]) {
            // @see https://stackoverflow.com/a/2556306
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", [NSString class]];
            NSArray *filteredKeys = [[(NSDictionary *)JSONObject allKeys] filteredArrayUsingPredicate:predicate];
            NSArray *keys = ordered ? ([filteredKeys sortedArrayUsingSelector:@selector(compare:)]) : filteredKeys;
            
            [stringM appendString:@"@{\n"];
            [keys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([key isKindOfClass:[NSString class]]) {
                    id value = [(NSDictionary *)JSONObject objectForKey:key];
                    NSString *literalString = [self literalStringWithJSONObject:value indentLevel:indentLevel + 1 startIndentLength:startIndentLength indentLength:indentLength ordered:ordered isRootContainer:NO];
                    if (literalString) {
                        if (!isFirstElement) {
                            [stringM appendString:@",\n"];
                        }
                        [stringM appendFormat:@"%@@\"%@\" : %@", indentSpaceForElement, key, literalString];
                        isFirstElement = NO;
                    }
                }
            }];
            [stringM appendFormat:@"\n%@}", indentSpaceForContainer];
        }
        else {
            [stringM appendString:@"@[\n"];
            [(NSArray *)JSONObject enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *literalString = [self literalStringWithJSONObject:obj indentLevel:indentLevel + 1 startIndentLength:startIndentLength indentLength:indentLength ordered:ordered isRootContainer:NO];
                if (literalString) {
                    if (!isFirstElement) {
                        [stringM appendString:@",\n"];
                    }
                    [stringM appendFormat:@"%@%@", indentSpaceForElement, literalString];
                    isFirstElement = NO;
                }
            }];
            [stringM appendFormat:@"\n%@]", indentSpaceForContainer];
        }
        
        return stringM;
    }
    else {
        return nil;
    }
}

// Convert NSString to JSON string
static NSString * JSONEscapedStringFromString(NSString *string) {
    NSMutableString *stringM = [NSMutableString stringWithString:string];
    
    // Note: `\` -> `\\`
    [stringM replaceOccurrencesOfString:@"\\" withString:@"\\\\" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    // Note: `"` -> `\"`
    [stringM replaceOccurrencesOfString:@"\"" withString:@"\\\"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    //[stringM replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    [stringM replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [stringM length])];
    
    return [NSString stringWithString:stringM];
}

#pragma mark ::

#pragma mark > JSON value comparison

+ (NSNumber *)compareNumbersRoughlyWithJSONValue1:(id)JSONValue1 JSONValue2:(id)JSONValue2 {
    if (![JSONValue1 isKindOfClass:[NSString class]] && ![JSONValue1 isKindOfClass:[NSNumber class]]) {
        return @(NSNotFound);
    }
    
    if (![JSONValue2 isKindOfClass:[NSString class]] && ![JSONValue2 isKindOfClass:[NSNumber class]]) {
        return @(NSNotFound);
    }
    
    double value1 = [JSONValue1 doubleValue];
    double value2 = [JSONValue2 doubleValue];
    
    if (value1 < value2) {
        return @(NSOrderedAscending);
    }
    else if (value1 > value2) {
        return @(NSOrderedDescending);
    }
    else {
        return @(NSOrderedSame);
    }
}

#pragma mark - Utility Methods

+ (nullable NSString *)stringByReplacingMatchesInString:(NSString *)string pattern:(NSString *)pattern captureGroupBindingBlock:(nullable NSString *(^)(NSString *matchString, NSArray<NSString *> *captureGroupStrings))captureGroupBindingBlock {
    
    if (!captureGroupBindingBlock) {
        return string;
    }
    
    NSMutableArray<NSValue *> *ranges = [NSMutableArray array];
    NSMutableArray<NSString *> *replacementStrings = [NSMutableArray array];
    BOOL status = [self enumerateMatchesInString:string pattern:pattern usingBlock:^(NSTextCheckingResult * _Nonnull result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        NSRange matchRange = result.range;
        if (matchRange.location != NSNotFound && matchRange.length > 0) {
            NSString *matchString = [WCJSONTool substringWithString:string range:matchRange];
            
            NSMutableArray *captureGroupStrings = [NSMutableArray array];
            for (NSInteger i = 1; i < result.numberOfRanges; i++) {
                NSRange captureRange = [result rangeAtIndex:i];
                if (captureRange.location != NSNotFound) {
                    NSString *captureGroupString = [WCJSONTool substringWithString:string range:captureRange];
                    [captureGroupStrings addObject:captureGroupString ?: @""];
                }
                else {
                    [captureGroupStrings addObject:@""];
                }
            }
            
            NSString *replacementString = captureGroupBindingBlock(matchString, captureGroupStrings);
            if (replacementString) {
                [ranges addObject:[NSValue valueWithRange:matchRange]];
                [replacementStrings addObject:replacementString];
            }
        }
    }];
    
    if (!status) {
        return string;
    }
    
    return [WCJSONTool replaceCharactersInRangesWithString:string ranges:ranges replacementStrings:replacementStrings replacementRanges:nil];
}

+ (BOOL)enumerateMatchesInString:(NSString *)string pattern:(NSString *)pattern usingBlock:(void (^)(NSTextCheckingResult *result, NSMatchingFlags flags, BOOL *stop))block {
    if (![string isKindOfClass:[NSString class]] || string.length == 0 || ![pattern isKindOfClass:[NSString class]] || pattern.length == 0) {
        return NO;
    }
    
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern options:kNilOptions error:&error];
    if (error) {
        return NO;
    }
    
    if (block) {
        // Note: string should not nil
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

+ (nullable NSString *)substringWithString:(NSString *)string range:(NSRange)range {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    if (range.location <= string.length) {
        // Note: Don't use range.location + range.length <= string.length, because if length is too large (e.g. NSUIntegerMax), location + length will become smaller (upper overflow)
        if (range.length <= string.length - range.location) {
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

+ (nullable NSString *)replaceCharactersInRangesWithString:(NSString *)string ranges:(NSArray<NSValue *> *)ranges replacementStrings:(NSArray<NSString *> *)replacementStrings replacementRanges:(inout nullable NSMutableArray<NSValue *> *)replacementRanges {
    
    if (![string isKindOfClass:[NSString class]] ||
        ![ranges isKindOfClass:[NSArray class]] ||
        ![replacementStrings isKindOfClass:[NSArray class]] ||
        ranges.count != replacementStrings.count) {
        return nil;
    }
    
    // Parameter check: replacementRanges
    if (replacementRanges && ![replacementRanges isKindOfClass:[NSMutableArray class]]) {
        return nil;
    }
    
    // Parameter check: replacementStrings
    for (NSString *element in replacementStrings) {
        if (![element isKindOfClass:[NSString class]]) {
            return nil;
        }
    }
    
    // Parameter check: ranges
    for (NSValue *value in ranges) {
        if (![value isKindOfClass:[NSValue class]]) {
            return nil;
        }
        
        NSRange range = [value rangeValue];
        if (range.location == NSNotFound || range.length == 0) {
            return nil;
        }
        
        if (!NSRangeContainsRange(NSMakeRange(0, string.length), range)) {
            return nil;
        }
    }
    
    // Note: empty array just return the original string
    if (ranges.count == 0 && replacementStrings.count == 0) {
        return string;
    }
    
    // Note: sort the ranges by ascend
    NSArray *sortedRanges = [ranges sortedArrayUsingComparator:^NSComparisonResult(NSValue * _Nonnull value1, NSValue * _Nonnull value2) {
        NSComparisonResult result = NSOrderedSame;
        if (value1.rangeValue.location > value2.rangeValue.location) {
            result = NSOrderedDescending;
        }
        else if (value1.rangeValue.location < value2.rangeValue.location) {
            result = NSOrderedAscending;
        }
        return result;
    }];
    
    NSRange previousRange = NSMakeRange(0, 0);
    for (NSInteger i = 0; i < sortedRanges.count; i++) {
        NSRange currentRange = [sortedRanges[i] rangeValue];
        // @see https://stackoverflow.com/a/10172768
        NSRange intersection = NSIntersectionRange(previousRange, currentRange);
        if (intersection.length > 0) {
            // Note: the two ranges does intersect
            return nil;
        }
        
        previousRange = currentRange;
    }
    
    NSInteger (^checkChacterInRanges)(NSRange) = ^NSInteger(NSRange rangeOfCharacter) {
        for (NSInteger i = 0; i < sortedRanges.count; i++) {
            NSRange currentRange = [sortedRanges[i] rangeValue];
            if (NSRangeContainsRange(currentRange, rangeOfCharacter)) {
                return i;
            }
        }
        
        return NSNotFound;
    };
    
    NSMutableArray<id> *replacementStringsM = [replacementStrings mutableCopy];
    [replacementRanges removeAllObjects];
    for (NSInteger i = 0; i < replacementStringsM.count; i++) {
        replacementRanges[i] = [NSValue valueWithRange:NSMakeRange(NSNotFound, 0)];
    }
    
    NSMutableString *stringM = [NSMutableString stringWithCapacity:string.length];
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSString *character = substring;
        NSRange rangeOfCharacter = substringRange;
        
        NSInteger index = checkChacterInRanges(rangeOfCharacter);
        if (index != NSNotFound) {
            NSValue *rangeValue = sortedRanges[index];
            
            // Note: find the index of the replacement string in unsorted array
            NSInteger indexOfReplacementString = [ranges indexOfObject:rangeValue];
            if (indexOfReplacementString != NSNotFound) {
                NSString *stringToInsert = replacementStringsM[indexOfReplacementString];
                
                // Note: allow to insert empty string and check it if [NSNull null]
                if (stringToInsert && [stringToInsert isKindOfClass:[NSString class]]) {
                    // Note: record the range of stringToInsert
                    NSRange replacementRange = NSMakeRange(stringM.length, stringToInsert.length);
                    replacementRanges[indexOfReplacementString] = [NSValue valueWithRange:replacementRange];
                    
                    [stringM appendString:stringToInsert];
                    
                    // Note: set the stringToInsert to [NSNull null] to avoid inserting again
                    replacementStringsM[indexOfReplacementString] = [NSNull null];
                }
            }
        }
        else {
            [stringM appendString:character];
        }
    }];
    
    return stringM;
}

+ (BOOL)checkNumberAsBooleanWithNumber:(NSNumber *)number {
    if (![number isKindOfClass:[NSNumber class]]) {
        return NO;
    }
    
    CFTypeID boolID = CFBooleanGetTypeID(); // the type ID of CFBoolean
    CFTypeID numID = CFGetTypeID((__bridge CFTypeRef)(number)); // the type ID of num
    return numID == boolID;
}

#pragma mark - Private Utility Functions

/**
 Check if NSRange contains the other NSRange

 @param range1 the range which is expected as super range
 @param range2 the range which is expected as sub range
 @return YES if range1 contains or equals range2, and otherwise NO.
 @see https://gist.github.com/wokalski/3130403
 */
static BOOL NSRangeContainsRange(NSRange range1, NSRange range2) {
    BOOL retval = NO;
    if (range1.location <= range2.location && range1.location + range1.length >= range2.length + range2.location) {
        retval = YES;;
    }
    
    return retval;
}

@end
