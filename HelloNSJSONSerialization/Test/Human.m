//
//  Human.m
//  Test
//
//  Created by wesley_chen on 2018/12/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "Human.h"

@implementation Finger
- (instancetype)initWithName:(NSString *)name index:(NSInteger)index {
    self = [super init];
    if (self) {
        _name = name;
        _index = index;
    }
    return self;
}
@end

@implementation Hand
- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
        
        NSMutableArray *fingers = [NSMutableArray array];
        // @see https://www.simplybodylanguage.com/finger-names.html
        [fingers addObject:[[Finger alloc] initWithName:@"Thumb" index:1]];
        [fingers addObject:[[Finger alloc] initWithName:@"Index finger" index:2]];
        [fingers addObject:[[Finger alloc] initWithName:@"Middle finger" index:3]];
        [fingers addObject:[[Finger alloc] initWithName:@"Ring finger" index:4]];
        [fingers addObject:[[Finger alloc] initWithName:@"Pinky" index:5]];
        
        _fingers = fingers;
    }
    return self;
}
@end

@implementation Human

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *hands = [NSMutableArray array];
        [hands addObject:[[Hand alloc] initWithName:@"Left Hand"]];
        [hands addObject:[[Hand alloc] initWithName:@"Right Hand"]];
        _hands = hands;
    }
    return self;
}

@end
