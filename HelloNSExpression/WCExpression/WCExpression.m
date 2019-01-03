//
//  WCExpression.m
//  HelloNSScanner
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCExpression.h"
#import <objc/runtime.h>

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
    WCExpression *instance = [[WCExpression alloc] initInternally];
    NSExpression *expression;
    @try {
        va_list args;
        va_start(args, format);
        expression = [NSExpression expressionWithFormat:format arguments:args];
        va_end(args);
    }
    @catch (NSException *e) {
        instance.log(@"[Error] format argument is not correct, exception: %@", e);
    }
    
    instance.formatString = [expression description];
    return instance;
}

// @see https://agilewarrior.wordpress.com/2016/04/07/objective-c-object-initialization/
- (instancetype)initInternally {
    self = [super init];
    if (self) {
        __weak typeof(self) weak_self = self;
        _categoryMethodPrefixTable = [NSMutableDictionary dictionary];
        _functionNameMapping = [NSMutableDictionary dictionary];
        _log = ^(NSString *format, ...) {
            if (weak_self.enableLogging) {
                va_list args;
                va_start(args, format);
                NSLogv(format, args);
                va_end(args);
            }
        };
#if DEBUG
        _enableLogging = YES;
#endif
    }
    
    return self;
}

- (nullable id)expressionValueWithObject:(nullable id)object context:(nullable NSMutableDictionary *)context {
    if (self.formatString) {
        NSArray<NSString *> *tokens = [self tokenizeWithFormatString:self.formatString];
        
        return [self evaluateWithTokens:tokens binding:object];
    }
    else {
        return nil;
    }
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
              @"+",
              @"-",
              @"*",
              @"/",
              @">",
              @"<",
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
    
    NSMutableCharacterSet *variableCharacterSet = [NSMutableCharacterSet letterCharacterSet];
    [variableCharacterSet formUnionWithCharacterSet:[NSCharacterSet decimalDigitCharacterSet]];
    [variableCharacterSet formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@".[]"]];
    
    while (![scanner isAtEnd]) {
        for (NSString *operator in self.operators) {
            if ([scanner scanString:operator intoString:NULL]) {
                [tokens addObject:operator];
            }
        }
        
        double doubleResult = 0;
        
        NSString *result = nil;
        NSUInteger previousLocation = scanner.scanLocation;
        if ([scanner scanCharactersFromSet:[NSCharacterSet letterCharacterSet] intoString:NULL]) {
            scanner.scanLocation = previousLocation;
            
            if ([scanner scanCharactersFromSet:variableCharacterSet intoString:&result]) {
                [tokens addObject:result];
            }
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

- (nullable id)evaluateWithTokens:(NSArray<NSString *> *)tokens binding:(id)binding {
    NSMutableArray *stack = [NSMutableArray arrayWithCapacity:tokens.count];
    
    for (NSInteger i = 0; i < tokens.count; i++) {
        id element = tokens[i];
        if ([element isKindOfClass:[NSString class]] && [element isEqualToString:@")"]) {
            NSMutableArray *functionComponents = [NSMutableArray array];
            [functionComponents insertObject:element atIndex:0];
            
            // Note: rewind to match (...)
            do {
                id elementAtTop = [stack firstObject];
                [stack removeObjectAtIndex:0];
                
                if ([elementAtTop isKindOfClass:[NSString class]] && [elementAtTop isEqualToString:@"("]) {
                    
                    // Note: look ahead one more step to check FUNCTION
                    id nextElementAtTop = [stack firstObject];
                    if ([nextElementAtTop isKindOfClass:[NSString class]] && [nextElementAtTop isEqualToString:@"FUNCTION"]) {
                        [stack removeObjectAtIndex:0];
                        
                        [functionComponents insertObject:elementAtTop atIndex:0];
                        [functionComponents insertObject:nextElementAtTop atIndex:0];
                        
                        // Format: FUNCTION (arg1, arg2, ...)
                        if (functionComponents.count >= 5) {
                            [self renameFunctionIfNeeded:functionComponents binding:binding];
                            BOOL valid = [self validateFunction:functionComponents binding:binding];
                            if (!valid) {
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
                    id expressionValue = nil;
                    @try {
                        NSExpression *expression = [NSExpression expressionWithFormat:expressionString];
                        expressionValue = [expression expressionValueWithObject:binding context:nil];
                    }
                    @catch (NSException *e) {
                        self.log(@"[Error] syntax error: %@, exception: %@", expressionString, e);
                    }
                    if (expressionValue == nil) {
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
        
        id expressionValue = nil;
        @try {
            NSExpression *expression = [NSExpression expressionWithFormat:plainExpressionString];
            expressionValue = [expression expressionValueWithObject:binding context:nil];
        }
        @catch (NSException *e) {
            self.log(@"[Error] syntax error: %@, exception: %@", plainExpressionString, e);
        }
        
        return expressionValue;
    }
    
    return nil;
}

- (void)renameFunctionIfNeeded:(NSMutableArray *)functionComponents binding:(id)binding {
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
            object = [binding valueForKey:arg1];
        }
        @catch (NSException *e) {
            self.log(@"[Warning] key `%@` not exists in %@", arg1, binding);
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

- (BOOL)validateFunction:(NSMutableArray *)functionComponents binding:(id)binding {
    // Format: FUNCTION (arg1, arg2, ...)
    if (functionComponents.count < 5) {
        return NO;
    }
    
    // Check function signature
    id arg1 = functionComponents[2];
    id arg2 = functionComponents[4];
    
    if (![arg1 isKindOfClass:[NSObject class]]) {
        return NO;
    }
    
    if (![arg2 isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    id sender = nil;
    if ([arg1 isKindOfClass:[NSString class]]) {
        if ([arg1 hasPrefix:@"\""] && [arg1 hasSuffix:@"\""]) {
            sender = [arg1 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
        }
        else {
            @try {
                sender = ([arg1 rangeOfString:@"."].location != NSNotFound) ? [binding valueForKeyPath:arg1] : [binding valueForKey:arg1];
            }
            @catch (NSException *e) {
                self.log(@"[Error] exception: %@", e);
                return NO;
            }
        }
    }
    else {
        sender = arg1;
    }
    
    NSString *functionName = [arg2 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];
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
        return NO;
    }
    
    if (![sender respondsToSelector:NSSelectorFromString(functionName)]) {
        return NO;
    }
    
    NSMethodSignature *signature = [sender methodSignatureForSelector:NSSelectorFromString(functionName)];
    if (count != signature.numberOfArguments - 2) {
        return NO;
    }
    
    const char *returnType = signature.methodReturnType;
    if (strcmp(returnType, "@") != 0) {
        return NO;
    }
    
    for (NSInteger i = 2; i < signature.numberOfArguments; i++) {
        const char *argumentType = [signature getArgumentTypeAtIndex:i];
        if (strcmp(argumentType, "@") != 0) {
            return NO;
        }
    }
    
    return YES;
}

@end
