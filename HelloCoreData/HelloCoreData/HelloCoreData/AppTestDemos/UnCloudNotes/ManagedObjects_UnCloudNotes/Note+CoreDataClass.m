//
//  Note+CoreDataClass.m
//  HelloCoreData
//
//  Created by wesley_chen on 11/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//
//

#import "Note+CoreDataClass.h"

@implementation Note

// Note: called when entity inserted into context
- (void)awakeFromInsert {
    [super awakeFromInsert];
    
    self.dateCreated = [NSDate date];
}

@end
