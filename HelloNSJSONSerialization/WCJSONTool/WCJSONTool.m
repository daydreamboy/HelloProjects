//
//  WCJSONTool.m
//  HelloNSJSONSerialization
//
//  Created by wesley_chen on 11/02/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCJSONTool.h"

@interface WCJSONTool ()
+ (NSString *)jsonStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options;
@end

@implementation NSArray (WCJSONTool)

- (NSString *)jsonString {
    return [WCJSONTool jsonStringWithObject:self printOptions:kNilOptions];
}

- (NSString *)jsonStringWithReadability {
    return [WCJSONTool jsonStringWithObject:self printOptions:NSJSONWritingPrettyPrinted];
}

@end

@implementation NSDictionary (WCJSONTool)

- (NSString *)jsonString {
    return [WCJSONTool jsonStringWithObject:self printOptions:kNilOptions];
}

- (NSString *)jsonStringWithReadability {
    return [WCJSONTool jsonStringWithObject:self printOptions:NSJSONWritingPrettyPrinted];
}

@end

@implementation WCJSONTool

/*!
 *  Get a json string
 *
 *  @sa http://stackoverflow.com/questions/6368867/generate-json-string-from-nsdictionary
 */
+ (NSString *)jsonStringWithObject:(id)object printOptions:(NSJSONWritingOptions)options {
    if ([object isKindOfClass:[NSArray class]] || [object isKindOfClass:[NSDictionary class]]) {
        NSData *jsonData = nil;
        @try {
            NSError *error;
            jsonData = [NSJSONSerialization dataWithJSONObject:object options:options error:&error];
        }
        @catch (NSException *exception) {
            if (![NSJSONSerialization isValidJSONObject:object]) {
                NSLog(@"[%@]: %@ is not a valid JSON object", NSStringFromClass(self), object);
            }
            else {
                NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass(self), exception);
            }
        }
        
        NSString *jsonString = nil;
        if (jsonData) {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        
        return jsonString;
    }
    else if ([object isKindOfClass:[NSString class]]) {
        return object;
    }
    else {
        return nil;
    }
}

+ (NSMutableDictionary *)mutableDictionaryWithJSONString:(NSString *)jsonString {
    return [self mutableContainerWithJSONData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] containerClass:[NSDictionary class]];
}

+ (NSMutableDictionary *)mutableDictionaryWithJSONData:(NSData *)jsonData {
    return [self mutableContainerWithJSONData:jsonData containerClass:[NSDictionary class]];
}

+ (NSMutableArray *)mutableArrayWithJSONString:(NSString *)jsonString {
    return [self mutableContainerWithJSONData:[jsonString dataUsingEncoding:NSUTF8StringEncoding] containerClass:[NSArray class]];
}

+ (NSMutableArray *)mutableArrayWithJSONData:(NSData *)jsonData {
    return [self mutableContainerWithJSONData:jsonData containerClass:[NSArray class]];
}

#pragma mark -

+ (id)mutableContainerWithJSONData:(NSData *)jsonData containerClass:(Class)class {
    if (!jsonData) {
        return nil;
    }
    
    NSString *className = NSStringFromClass(class);
    if ([className isEqualToString:NSStringFromClass([NSArray class])] || [className isEqualToString:NSStringFromClass([NSDictionary class])]) {
        NSError *error;
        @try {
            id mutableContainer = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&error];
            if (mutableContainer && [mutableContainer isKindOfClass:class]) {
                return mutableContainer;
            }
        }
        @catch (NSException *exception) {
            NSLog(@"[%@] an exception occured:\n%@", NSStringFromClass(self), exception);
        }
    }

    return nil;
}

@end
