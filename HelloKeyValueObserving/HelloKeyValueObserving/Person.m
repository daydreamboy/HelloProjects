//
//  Person.m
//  HelloKeyValueObserving
//
//  Created by wesley chen on 17/2/12.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "Person.h"
#import "Account.h"

static void *sPersonContext = &sPersonContext;

@implementation Person

- (NSString *)fullName {
    return [NSString stringWithFormat:@"%@ %@", _firstName, _lastName];
}

- (void)addAccount:(Account *)account {
    
    if (!_accounts) {
        _accounts = [NSMutableArray array];
    }
    
    [_accounts addObject:account];
    [account addObserver:self forKeyPath:@"openingBalance" options:NSKeyValueObservingOptionNew context:sPersonContext];
    
    _totalOfOpeningBalance += account.openingBalance;
}

- (Account *)accountWithName:(NSString *)name {
    Account *account = nil;
    for (Account *acct in _accounts) {
        if ([acct.name isEqualToString:name]) {
            account = acct;
            break;
        }
    }
    return account;
}

- (void)removeAllAccounts {
    for (Account *acct in _accounts) {
        @try {
            [acct removeObserver:self forKeyPath:@"openingBalance"];
        } @catch (NSException * __unused exception) {
        }
    }
    [_accounts removeAllObjects];
}

#pragma mark - KVO

+ (NSSet<NSString *> *)keyPathsForValuesAffectingValueForKey:(NSString *)key {
    NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
    
    if ([key isEqualToString:@"fullName"]) {
        NSArray *affectingKeys = @[@"firstName", @"lastName"];
        keyPaths = [keyPaths setByAddingObjectsFromArray:affectingKeys];
    }
    return keyPaths;
}

+ (NSSet *)keyPathsForValuesAffectingFullName {
    return [NSSet setWithObjects:@"firstName", @"lastName", nil];
}

+ (BOOL)automaticallyNotifiesObserversOfTotalOfOpeningBalance {
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == sPersonContext) {
        [self updateTotalOfOpeningBalance];
    }
    else {
        // deal with other observations and/or invoke super...
    }
}

- (void)updateTotalOfOpeningBalance {
    [self setTotalOfOpeningBalance:[[self valueForKeyPath:@"accounts.@sum.openingBalance"] doubleValue]];
}

- (void)setTotalOfOpeningBalance:(double)totalOfOpeningBalance {
    if (_totalOfOpeningBalance != totalOfOpeningBalance) {
        [self willChangeValueForKey:@"totalOfOpeningBalance"];
        
        _totalOfOpeningBalance = totalOfOpeningBalance;
        
        [self didChangeValueForKey:@"totalOfOpeningBalance"];
    }
}

@end
