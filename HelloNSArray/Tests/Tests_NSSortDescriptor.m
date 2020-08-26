//
//  Tests_NSSortDescriptor.m
//  Tests
//
//  Created by wesley_chen on 2020/8/17.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Conversation : NSObject
@property (nonatomic, assign) long long modifyTime;
@property (nonatomic, assign) long long topRank;
@end

@implementation Conversation
- (instancetype)initWithModifyTime:(long long)modifyTime topRank:(long long)topRank {
    self = [super init];
    if (self) {
        _modifyTime = modifyTime;
        _topRank = topRank;
    }
    return self;
}
- (NSString *)description {
    return [NSString stringWithFormat:@"<%p: %@, modifyTime = %lld; topRank = %lld>", self, NSStringFromClass([self class]), self.modifyTime, self.topRank];
}
@end

@interface Tests_NSSortDescriptor : XCTestCase
@property (nonatomic, strong) NSArray<Conversation *> *conversations;
@end

@implementation Tests_NSSortDescriptor

- (void)setUp {
    self.conversations = @[
        [[Conversation alloc] initWithModifyTime:1597374249859 topRank:1597289100627],
        [[Conversation alloc] initWithModifyTime:1597317194881 topRank:1596706460397],
        [[Conversation alloc] initWithModifyTime:1597497105687 topRank:1596536358298],
        [[Conversation alloc] initWithModifyTime:1597634296972 topRank:0],
        [[Conversation alloc] initWithModifyTime:1597634296975 topRank:0],
    ];
}

- (void)tearDown {
    
}

- (void)test_sortedArrayUsingComparator {
    NSArray *output;
    
    NSSortDescriptor *sorter1 = [NSSortDescriptor sortDescriptorWithKey:@"topRank" ascending:NO];
    NSSortDescriptor *sorter2 = [NSSortDescriptor sortDescriptorWithKey:@"modifyTime" ascending:NO];
    
    output = [self.conversations sortedArrayUsingDescriptors:@[sorter1, sorter2]];
    
    // @see https://stackoverflow.com/questions/29530620/sort-array-of-objects-by-two-properties
    output = [self.conversations sortedArrayUsingComparator:^NSComparisonResult(Conversation *conversation1, Conversation *conversation2) {
        
        if (conversation1.topRank > 0 && conversation2.topRank == 0) {
            return NSOrderedAscending;
        }
        
        if (conversation1.topRank == 0 && conversation2.topRank > 0) {
            return NSOrderedDescending;
        }
        
        // Case
        // - conversation1.topRank > 0 && conversation2.topRank > 0
        // - conversation1.topRank == 0 && conversation2.topRank == 0
        if (conversation1.modifyTime > conversation2.modifyTime) {
            return NSOrderedAscending;
        }
        else if (conversation1.modifyTime < conversation2.modifyTime) {
            return NSOrderedDescending;
        }
        else {
            return NSOrderedSame;
        }
    }];
    
    NSLog(@"%@", output);
}

@end
