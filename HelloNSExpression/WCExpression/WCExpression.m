//
//  WCExpression.m
//  HelloNSScanner
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCExpression.h"

#ifndef NSPREDICATE
#define NSPREDICATE(expression)    ([NSPredicate predicateWithFormat:@"SELF MATCHES %@", expression])
#endif

@interface WCExpression ()
@property (nonatomic, strong) NSExpression *expression;
@property (nonatomic, copy, readwrite) NSString *formatString;
@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, NSString *> *categoryMethodPrefixTable;
@property (nonatomic, strong, readwrite) NSMutableDictionary<NSString *, NSString *> *functionNameMapping;
@property (nonatomic, strong) NSArray *operators;
@property (nonatomic, copy) void (^log)(NSString *, ...);
@end

@implementation WCExpression

+ (instancetype)expressionWithFormat:(NSString *)format, ... {
    WCExpression *instance = [WCExpression new];
    __weak typeof(instance) weak_instance = instance;
    va_list args;
    va_start(args, format);
    NSExpression *expression = [NSExpression expressionWithFormat:format arguments:args];
    instance.formatString = [expression description];
    instance.categoryMethodPrefixTable = [NSMutableDictionary dictionary];
    instance.functionNameMapping = [NSMutableDictionary dictionary];
    instance.log = ^(NSString *format, ...) {
        if (weak_instance.enableLogging) {
            va_list args2;
            va_start(args2, format);
            NSLogv(format, args2);
            va_end(args2);
        }
    };
    va_end(args);
    
#if DEBUG
    instance.enableLogging = YES;
#endif
    
    return instance;
}

- (nullable id)expressionValueWithObject:(nullable id)object context:(nullable NSMutableDictionary *)context {
    NSArray<NSString *> *tokens = [self tokenizeWithFormatString:self.formatString];
    
    return [self evaluateWithTokens:tokens variables:object];
}

#pragma mark - Getters

- (NSArray *)operators {
    return @[
              @"**",
              @">=",
              @"=>",
              @"<=",
              @"=<",
              @"<<",
              @">>",
              @"[",
              @"]",
              @"+",
              @"-",
              @"*",
              @"/",
              @">",
              @"<",
              @".",
              @"(",
              @")",
              @"&",
              @"|",
              @"~",
              @"^",
              @"," ];
}

#pragma mark -

- (NSArray<NSString *> *)tokenizeWithFormatString:(NSString *)string {
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSMutableArray *tokens = [NSMutableArray array];
    
    while (![scanner isAtEnd]) {
        for (NSString *operator in self.operators) {
            if ([scanner scanString:operator intoString:NULL]) {
                [tokens addObject:operator];
            }
        }
        
        double doubleResult = 0;
        
        NSString *result = nil;
        if ([scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:&result]) {
            [tokens addObject:result];
        }
        else if ([scanner scanString:@"\"" intoString:NULL]) {
            NSString *outString;
            NSCharacterSet *charactersToBeSkipped = scanner.charactersToBeSkipped;
            scanner.charactersToBeSkipped = nil;
            [scanner scanUpToString:@"\"" intoString:&outString];
            [scanner scanString:@"\"" intoString:NULL];
            scanner.charactersToBeSkipped = charactersToBeSkipped;
            
            [tokens addObject:[NSString stringWithFormat:@"\"%@\"", outString]];
        }
        else if ([scanner scanDouble:&doubleResult]) {
            [tokens addObject:@(doubleResult)];
        }
        else {
            self.log(@"[DEBUG] not hit. left string: `%@`", [scanner.string substringFromIndex:scanner.scanLocation]);
        }
    }
    
    return tokens;
}

- (nullable id)evaluateWithTokens:(NSArray<NSString *> *)tokens variables:(id)variables {
    NSMutableArray *stack = [NSMutableArray arrayWithCapacity:tokens.count];
    
    for (NSInteger i = 0; i < tokens.count; i++) {
        id element = tokens[i];
        if ([element isKindOfClass:[NSString class]] && [element isEqualToString:@")"]) {
            NSMutableArray *functionComponents = [NSMutableArray array];
            [functionComponents insertObject:element atIndex:0];
            
            do {
                id elementAtTop = [stack firstObject];
                [stack removeObjectAtIndex:0];
                
                if ([elementAtTop isKindOfClass:[NSString class]] && [elementAtTop isEqualToString:@"("]) {
                    
                    id nextElementAtTop = [stack firstObject];
                    if ([nextElementAtTop isKindOfClass:[NSString class]] && [nextElementAtTop isEqualToString:@"FUNCTION"]) {
                        [stack removeObjectAtIndex:0];
                        
                        [functionComponents insertObject:elementAtTop atIndex:0];
                        [functionComponents insertObject:nextElementAtTop atIndex:0];
                        
                        // Format: FUNCTION (arg1, arg2, ...)
                        if (functionComponents.count >= 5) {
                            [self renameFunctionIfNeeded:functionComponents variables:variables];
                            
                            // Check function signature
                            NSString *functionName = functionComponents[4];
                            NSUInteger numberOfArguments = [functionName componentsSeparatedByString:@":"].count - 1;
                            
                            NSUInteger count = 0;
                            // 0           1    2    3    4
                            // `FUNCTION`, `(`, `a`, `,`, `"my_pow:"`, ...
                            for (NSInteger i = 5; i < functionComponents.count; i++) {
                                if ([functionComponents[i] isKindOfClass:[NSString class]] && (
                                    [functionComponents[i] isEqualToString:@","] ||
                                    [functionComponents[i] isEqualToString:@")"])) {
                                    continue;
                                }
                                else {
                                    count++;
                                }
                            }
                            if (count != numberOfArguments) {
                                self.log(@"[Error] functionName not match number of arguments: %@, expect %@ args but %@ args", functionName, @(numberOfArguments), @(count));
                                return nil;
                            }
                        }
                        else {
                            self.log(@"[Error] functionComponents is malformed: %@", functionComponents);
                            return nil;
                        }
                    }
                    else {
                        [functionComponents insertObject:elementAtTop atIndex:0];
                    }
                    
                    NSString *expressionString = [functionComponents componentsJoinedByString:@" "];
                    NSExpression *expression = [NSExpression expressionWithFormat:expressionString];
                    id expressionValue = [expression expressionValueWithObject:variables context:nil];
                    if (expressionValue == nil) {
                        self.log(@"[Error] syntax error: %@", expressionString);
                        return nil;
                    }
                    else if ([expressionValue isKindOfClass:[NSString class]]) {
                        expressionValue = [NSString stringWithFormat:@"'%@'", expressionValue];
                    }
                    
                    [stack insertObject:expressionValue atIndex:0];
                    
                    break;
                }
                else {
                    [functionComponents insertObject:elementAtTop atIndex:0];
                }
            } while (1);
        }
        else {
            [stack insertObject:element atIndex:0];
        }
    }
    
    if (stack.count) {
        NSString *plainExpressionString;
        
        if (stack.count == 1) {
            id value = [stack firstObject];
            if ([value isKindOfClass:[NSString class]]) {
                plainExpressionString = value;
            }
            else {
                return value;
            }
        }
        else if (stack.count > 1) {
            // @see https://stackoverflow.com/a/586529
            NSArray *tokens = [[stack reverseObjectEnumerator] allObjects];
            plainExpressionString = [tokens componentsJoinedByString:@" "];
        }
        
        NSExpression *expression = [NSExpression expressionWithFormat:plainExpressionString];
        id expressionValue = [expression expressionValueWithObject:variables context:nil];
        if (expressionValue == nil) {
            self.log(@"[Error] syntax error: %@", plainExpressionString);
            return nil;
        }
        else {
            return expressionValue;
        }
    }
    
    return nil;
}

- (void)renameFunctionIfNeeded:(NSMutableArray *)functionComponents variables:(id)variables {
    id arg1 = functionComponents[2];
    NSString *arg2 = functionComponents[4];
    NSString *functionName = [arg2 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
    NSString *keyForPrefix;
    
    // 1. do function name mapping
    if (self.functionNameMapping[functionName]) {
        if ([functionName componentsSeparatedByString:@":"].count == [self.functionNameMapping[functionName] componentsSeparatedByString:@":"].count) {
            arg2 = [NSString stringWithFormat:@"\"%@\"", self.functionNameMapping[functionName]];
            functionComponents[4] = arg2;
        }
        else {
            self.log(@"[Warning] %@ not matches %@, ignore mapping", self.functionNameMapping[arg2], arg2);
        }
    }
    
    // 2. do prefixing
    if ([arg1 isKindOfClass:[NSString class]]) {
        // string
        keyForPrefix = NSStringFromClass([NSString class]);
    }
    else if ([arg1 isKindOfClass:[NSNumber class]]) {
        // number
        keyForPrefix = NSStringFromClass([NSNumber class]);
    }
    else if ([arg1 isKindOfClass:[NSObject class]]) {
        // variable
        id object;
        @try {
            object = [variables valueForKey:arg1];
        }
        @catch (NSException *e) {
            self.log(@"[Warning] key `%@` not exists in %@", arg1, variables);
        }
        if (object) {
            keyForPrefix = NSStringFromClass([object class]);
        }
    }
    else {
        // unknown identifier
        self.log(@"[Error] unknown identifier: %@", arg1);
    }
    
    if (keyForPrefix && self.categoryMethodPrefixTable[keyForPrefix]) {
        NSString *prefixedFunctionName = [NSString stringWithFormat:@"\"%@%@\"", self.categoryMethodPrefixTable[keyForPrefix], [arg2 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]]];
        functionComponents[4] = prefixedFunctionName;
    }
}

@end
