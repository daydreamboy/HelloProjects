//
//  Person.m
//  HelloKeyValueCoding
//
//  Created by wesley_chen on 2019/7/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "Person.h"
#import "Account.h"

@implementation Person

@synthesize age = _age;
@synthesize name = _name;

- (instancetype)initWithAge:(NSUInteger)age {
    self = [super init];
    if (self) {
        _age = age;
    }
    return self;
}

- (NSString *)name {
    return _name;
}

- (void)setName:(NSString *)name {
    _name = name;
}

- (void)addAccount:(Account *)account {
    if (!_accounts) {
        _accounts = [NSMutableArray array];
    }
    
    [_accounts addObject:account];
}

- (BOOL)validateName:(inout id  _Nullable __autoreleasing *)ioValue error:(out NSError *__autoreleasing  _Nullable *)outError {
    if (ioValue == NULL) {
        if (outError) {
            *outError = [NSError errorWithDomain:@"KVCDomaine" code:-1 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"Invalid parameter" }];
        }
        return NO;
    }
    
    NSString *name = *ioValue;
    
    if (name && ![name isKindOfClass:[NSString class]]) {
        if (outError) {
            *outError = [NSError errorWithDomain:@"KVCDomaine" code:-1 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"Invalid parameter" }];
        }
        return NO;
    }
    
    if (self.name == name) {
        return YES;
    }
    
    // Note: name is safe NSString object
    if ([self.name isKindOfClass:[NSString class]] &&
        [name isEqual:self.name]) {
        return YES;
    }
    
    if (outError) {
        *outError = [NSError errorWithDomain:@"KVCDomaine" code:-1 userInfo:@{ NSLocalizedFailureReasonErrorKey: @"Value not match" }];
    }
    
    return NO;
}

@end
