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

#pragma mark - Public Methods

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
#define NSRangeZero (NSMakeRange(0, 0))
    if (![urlString isKindOfClass:[NSString class]] || urlString.length == 0) {
        return nil;
    }
    
    WCURLComponents *components = [[WCURLComponents alloc] init];
    
    NSTextCheckingResult *match = [self firstMatchInString:urlString pattern:self.patternOfURI];
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
        
        components.string = urlString;
        components.scheme = schemeComponent;
        components.query = queryComponent;
        components.fragment = fragmentComponent;
        
        components.rangeOfScheme = components.scheme.length > 0 ? schemeRange : NSRangeZero;
        components.rangeOfQuery = components.query.length > 0 ? queryRange : NSRangeZero;
        components.rangeOfFragment = fragmentComponent.length > 0 ? fragmentRange : NSRangeZero;
        
        NSTextCheckingResult *matchOfAuthorityComponent = [self firstMatchInString:authorityComponent pattern:self.patternOfAuthorityComponent];
        if (matchOfAuthorityComponent.numberOfRanges == 5) {
            NSRange userRange = [matchOfAuthorityComponent rangeAtIndex:1];
            NSRange passwordRange = [matchOfAuthorityComponent rangeAtIndex:2];
            NSRange hostRange = [matchOfAuthorityComponent rangeAtIndex:3];
            NSRange portRange = [matchOfAuthorityComponent rangeAtIndex:4];
            
            components.user = [self substringWithString:authorityComponent range:userRange];
            components.password = [self substringWithString:authorityComponent range:passwordRange];
            components.host = [self substringWithString:authorityComponent range:hostRange];
            components.port = [self numberFromString:[self substringWithString:authorityComponent range:portRange] encodedType:@encode(int)];
            
            components.rangeOfUser = components.user.length > 0 ? NSMakeRange(userRange.location + authorityRange.location, userRange.length) : NSRangeZero;
            components.rangeOfPassword = components.password.length > 0 ? NSMakeRange(passwordRange.location + authorityRange.location, passwordRange.length) : NSRangeZero;
            components.rangeOfHost = components.host.length > 0 ? NSMakeRange(hostRange.location + authorityRange.location, hostRange.length) : NSRangeZero;
            components.rangeOfPort = components.port.integerValue > 0 ? NSMakeRange(portRange.location + authorityRange.location, portRange.length) : NSRangeZero;
        }
        
        NSTextCheckingResult *matchOfPathComponent = [self firstMatchInString:pathComponent pattern:self.patternOfPathComponent];
        if (matchOfPathComponent.numberOfRanges == 3) {
            NSRange wellKnownPathRange = [matchOfPathComponent rangeAtIndex:1];
            NSRange parameterRange = [matchOfPathComponent rangeAtIndex:2];
            
            components.path = [self substringWithString:pathComponent range:wellKnownPathRange];
            components.parameterString = [self substringWithString:pathComponent range:parameterRange];
            
            components.rangeOfPath = components.path.length > 0 ? NSMakeRange(wellKnownPathRange.location + pathRange.location, wellKnownPathRange.length) : NSRangeZero;
            components.rangeOfParameterString = components.parameterString.length > 0 ? NSMakeRange(parameterRange.location + pathRange.location, parameterRange.length) : NSRangeZero;
            
            NSTextCheckingResult *matchOfPathExtension = [self firstMatchInString:components.path pattern:self.patternOfPathExtension];
            if (matchOfPathExtension.numberOfRanges == 2) {
                NSRange pathExtensionRange = [matchOfPathExtension rangeAtIndex:1];
                
                components.pathExtension = [self substringWithString:components.path range:pathExtensionRange];
                
                components.rangeOfPathExtension = components.pathExtension > 0 ? NSMakeRange(pathExtensionRange.location + components.rangeOfPath.location, pathExtensionRange.length) : NSRangeZero;
            }
        }
        
        if (queryComponent.length) {
            NSMutableArray<WCURLQueryItem *> *queryItemsM = [NSMutableArray array];
            NSMutableDictionary<NSString *, NSString *> *keyValuesM = [NSMutableDictionary dictionary];
            BOOL success = [self enumerateMatchesInString:queryComponent pattern:self.patternOfQueryItems usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                NSTextCheckingResult *matchOfQueryItems = result;
                
                if (matchOfQueryItems.numberOfRanges == 3) {
                    NSRange keyRange = [matchOfQueryItems rangeAtIndex:1];
                    NSRange valueRange = [matchOfQueryItems rangeAtIndex:2];
                    
                    NSString *key = [self substringWithString:queryComponent range:keyRange];
                    NSString *value = [self substringWithString:queryComponent range:valueRange];
                    
                    WCURLQueryItem *queryItem = [WCURLQueryItem queryItemWithName:key value:value];
                    queryItem.queryString = queryComponent;
                    queryItem.rangeOfName = key.length > 0 ? NSMakeRange(keyRange.location + components.rangeOfQuery.location, keyRange.length) : NSRangeZero;
                    queryItem.rangeOfValue = value.length > 0 ? NSMakeRange(valueRange.location + components.rangeOfQuery.location, valueRange.length) : NSRangeZero;
                    
                    [queryItemsM addObject:queryItem];
                    
                    if (key && value) {
                        keyValuesM[key] = value;
                    }
                }
            }];
            
            if (success && queryItemsM.count) {
                components.queryItems = queryItemsM;
            }
            
            if (success && keyValuesM.count) {
                components.queryKeyValues = keyValuesM;
            }
        }
    }
    
    return components;
#undef NSRangeZero
}

#pragma mark - Append/Replace Key Values

+ (nullable NSURL *)URLWithURL:(NSURL *)URL toAppendQueryKeyValues:(nullable NSDictionary<NSString *, NSString *> *)queryKeyValues options:(WCURLQueryKeyValueAppendOption)options {
    if (![URL isKindOfClass:[NSURL class]]) {
        return nil;
    }
    
    if (queryKeyValues && ![queryKeyValues isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (!queryKeyValues.count) {
        return URL;
    }
    
    NSMutableArray<KeyValuePairType> *itemsToAdd = [NSMutableArray array];
    [queryKeyValues enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSString * _Nonnull value, BOOL * _Nonnull stop) {
        if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]] &&
             key.length && value.length) {
            [itemsToAdd addObject:KeyValuePair(key, value)];
        }
    }];
    
    if (!itemsToAdd.count) {
        return URL;
    }
    
    return [self URLWithURL:URL toAppendQueryKeyValueArray:itemsToAdd options:options];
}

+ (nullable NSURL *)URLWithURL:(NSURL *)URL toAppendQueryKey:(NSString *)key value:(NSString *)value options:(WCURLQueryKeyValueAppendOption)options {
    if (![URL isKindOfClass:[NSURL class]] || ![key isKindOfClass:[NSString class]] || ![value isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    return [self URLWithURL:URL toAppendQueryKeyValueArray:@[KeyValuePair(key, value)] options:options];
}

+ (nullable NSURL *)URLWithURL:(NSURL *)URL toAppendQueryKeyValueArray:(nullable NSArray<KeyValuePairType> *)queryKeyValueArray options:(WCURLQueryKeyValueAppendOption)options {
    if (![URL isKindOfClass:[NSURL class]] || (queryKeyValueArray && ![queryKeyValueArray isKindOfClass:[NSArray class]])) {
        return nil;
    }
    
    if (!queryKeyValueArray.count) {
        return URL;
    }
    
    NSMutableArray<NSURLQueryItem *> *keyValuesToAdd = [NSMutableArray arrayWithCapacity:queryKeyValueArray.count];
    for (KeyValuePairType pair in queryKeyValueArray) {
        if (KeyValuePairValidate(pair)) {
            NSString *key = KeyOfPair(pair);
            NSString *value = ValueOfPair(pair);
            if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]] &&
                key.length && value.length) {
                [keyValuesToAdd addObject:[NSURLQueryItem queryItemWithName:key value:value]];
            }
        }
    }
    
    if (!keyValuesToAdd.count) {
        return URL;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    
    NSMutableArray<NSURLQueryItem *> *queryKeyValuesM = [NSMutableArray arrayWithCapacity:components.queryItems.count + queryKeyValueArray.count];
    
    if (options == WCURLQueryKeyValueAppendOptionAppendOnlyKeyNotExists) {
        NSArray *keysToRemove = [components.queryItems valueForKey:@"name"];
        
        NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(NSURLQueryItem * _Nullable evaluatedObject, NSDictionary<NSString *,id> * _Nullable bindings) {
            // return YES if keep the item in the filtered array
            return ![keysToRemove containsObject:evaluatedObject.name];
        }];
        [keyValuesToAdd filterUsingPredicate:predicate];
        
        [queryKeyValuesM addObjectsFromArray:components.queryItems];
        if (keyValuesToAdd.count) {
            [queryKeyValuesM addObjectsFromArray:keyValuesToAdd];
        }
    }
    else {
        [queryKeyValuesM addObjectsFromArray:components.queryItems];
        [queryKeyValuesM addObjectsFromArray:keyValuesToAdd];
    }
    
    components.queryItems = queryKeyValuesM;
    
    return components.URL;
}

+ (nullable NSURL *)URLWithURL:(NSURL *)URL replacedByQueryKeyValueArray:(nullable NSArray<KeyValuePairType> *)queryKeyValueArray scheme:(nullable NSString *)scheme options:(WCURLQueryKeyValueReplacementOption)options {
    if (![URL isKindOfClass:[NSURL class]] ||
        (queryKeyValueArray && ![queryKeyValueArray isKindOfClass:[NSArray class]]) ||
        (scheme && ![scheme isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    NSMutableArray<NSURLQueryItem *> *queryKeyValuesM = [NSMutableArray arrayWithCapacity:components.queryItems.count + queryKeyValueArray.count];
    
    if (queryKeyValueArray.count) {
        NSMutableArray<KeyValuePairType> *newKeyValuesToAppend = [NSMutableArray arrayWithArray:queryKeyValueArray];
        
        for (NSURLQueryItem *item in components.queryItems) {
            NSURLQueryItem *itemToAdd = [NSURLQueryItem queryItemWithName:item.name value:item.value];
            
            for (KeyValuePairType pair in queryKeyValueArray) {
                if (KeyValuePairValidate(pair)) {
                    NSString *key = pair[0];
                    NSString *value = pair[1];

                    // Note: if the key exists
                    if ([key isKindOfClass:[NSString class]] && key.length && [item.name isEqualToString:key]) {
                        
                        if ([value isKindOfClass:[NSString class]] && value.length) {
                            // to replace
                            itemToAdd = [NSURLQueryItem queryItemWithName:key value:value];
                            [newKeyValuesToAppend removeObject:pair];
                            break;
                        }
                        else if ([value isKindOfClass:[NSNull class]]) {
                            // to remove if value is NSNull
                            itemToAdd = nil;
                            [newKeyValuesToAppend removeObject:pair];
                            break;
                        }
                    }
                }
            }
            
            if (itemToAdd) {
                [queryKeyValuesM addObject:itemToAdd];
            }
        }
        
        if (!(options & WCURLQueryKeyValueReplacementOptionReplaceOnlyKeyExists)) {
            // Note: append the key values when the keys not exist in the original URL
            for (KeyValuePairType pair in newKeyValuesToAppend) {
                if (KeyValuePairValidate(pair)) {
                    NSString *key = KeyOfPair(pair);
                    NSString *value = ValueOfPair(pair);
                    if ([key isKindOfClass:[NSString class]] && [value isKindOfClass:[NSString class]] &&
                        key.length && value.length) {
                        [queryKeyValuesM addObject:[NSURLQueryItem queryItemWithName:key value:value]];
                    }
                }
            }
        }
    }
    else {
        [queryKeyValuesM addObjectsFromArray:components.queryItems];
    }
    
    if (options & WCURLQueryKeyValueReplacementOptionReorder) {
        NSSortDescriptor *sorter1 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(compare:)];
        NSSortDescriptor *sorter2 = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES selector:@selector(compare:)];
        [queryKeyValuesM sortUsingDescriptors:@[ sorter1, sorter2 ]];
    }
    
    components.queryItems = queryKeyValuesM;
    if (scheme.length) {
        components.scheme = scheme;
    }
    
    return components.URL;
}

#pragma mark - Remove All Key Values

+ (nullable NSURL *)baseURLWithURL:(NSURL *)URL {
    if (![URL isKindOfClass:[NSURL class]]) {
        return nil;
    }
    
    if (([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)) {
        NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:NO];
        URLComponents.query = nil;
        
        return URLComponents.URL;
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        return [[NSURL alloc] initWithScheme:URL.scheme host:URL.host path:URL.path];
#pragma GCC diagnostic pop
    }
}

#pragma mark - Sort Key Values

+ (nullable NSURL *)sortKeyValuesWithURL:(NSURL *)URL {
    if (![URL isKindOfClass:[NSURL class]]) {
        return nil;
    }
    
    NSURLComponents *components = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    if (!components.queryItems.count) {
        return URL;
    }
    
    NSMutableArray<NSURLQueryItem *> *queryKeyValuesM = [NSMutableArray arrayWithArray:components.queryItems];
    
    NSSortDescriptor *sorter1 = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(compare:)];
    NSSortDescriptor *sorter2 = [NSSortDescriptor sortDescriptorWithKey:@"value" ascending:YES selector:@selector(compare:)];
    [queryKeyValuesM sortUsingDescriptors:@[ sorter1, sorter2 ]];
    components.queryItems = queryKeyValuesM;
    
    return components.URL;
}

#pragma mark - Query Key Value

+ (nullable NSArray<NSString *> *)URLWithURL:(NSURL *)URL valueForKey:(NSString *)key {
    if (![URL isKindOfClass:[NSURL class]] ||
        ![key isKindOfClass:[NSString class]] ||
        ([key isKindOfClass:[NSString class]] && key.length == 0)) {
        return nil;
    }
    
    NSURLComponents *URLComponents = [[NSURLComponents alloc] initWithURL:URL resolvingAgainstBaseURL:NO];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name LIKE %@", key];
    NSArray<NSURLQueryItem *> *queryItems = [URLComponents.queryItems filteredArrayUsingPredicate:predicate];
    NSArray<NSString *> *values = [queryItems valueForKeyPath:@"self.value"];
    
    return values;
}

#pragma mark > Properties

+ (NSString *)patternOfURI {
    // @see https://tools.ietf.org/html/rfc2396
    //        12                3      4              5         6    7        8 9
    return @"^(([^:\\/\\?#]+):)?(\\/\\/([^\\/\\?#]*))?([^\\?#]*)(\\\?([^#]*))?(#(.*))?";
}

+ (NSString *)patternOfAuthorityComponent {
    // @see https://stackoverflow.com/a/39811696 e.g. <username>:<password>@<host>:<port>
    //          1       2         3            4
    return @"(?:([^:]*):([^@]*)@|)([^/:]{1,}):?(\\d*)?";
}

+ (NSString *)patternOfPathComponent {
    // @see https://stackoverflow.com/a/39811696
    //       1              2
    return @"(\\/[^;]{0,});?([^;]+)?";
}

+ (NSString *)patternOfQueryItems {
    // @see https://stackoverflow.com/a/46885117
    //                 1        2
    return @"(?:^|[?&])([^=&]*)=([^&]*)";
}

+ (NSString *)patternOfPathExtension {
    // @see https://stackoverflow.com/a/31481242
    //          1
    return @"\\.([^/?;.]+)(?:$|\\?|;)";
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

// Note: refer to +[WCStringTool substringWithString:range:]
+ (nullable NSString *)substringWithString:(NSString *)string range:(NSRange)range {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    if (range.location <= string.length) {
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
