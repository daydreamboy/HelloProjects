//
//  Name.m
//  Tests
//
//  Created by wesley_chen on 2020/8/11.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "Name.h"

@implementation Name

+ (instancetype)nameWithPatterns:(NSArray<NSString *> *)patterns {
    Name *name = [[Name alloc] init];
    
    NSMutableOrderedSet *set = [[NSMutableOrderedSet alloc] init];
    [set addObjectsFromArray:patterns];
    name.patterns = set;
    
    return name;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@", [[self.patterns array] componentsJoinedByString:@","]];
}

@end
