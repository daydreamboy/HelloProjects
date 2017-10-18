//
//  JournalEntry+CoreDataClass.m
//  HelloCoreData
//
//  Created by wesley_chen on 18/10/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//
//

#import "JournalEntry.h"

@implementation JournalEntry

- (NSString *)stringForDate {
    NSDateFormatter *dateFormater = [NSDateFormatter new];
    dateFormater.dateStyle = NSDateFormatterShortStyle;
    
    return [dateFormater stringFromDate:self.date];
}

@end
