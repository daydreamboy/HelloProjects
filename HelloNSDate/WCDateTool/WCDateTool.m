//
//  WCDateTool.m
//  HelloNSDate
//
//  Created by wesley_chen on 2019/4/9.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCDateTool.h"

@interface WCDateTool ()
+ (NSCalendar *)currentCalendar;
@end

@interface WCDateComponents ()
@property (nonatomic, strong, readwrite) NSDate *date;
@property (nonatomic, strong) NSDateComponents *components;
@end

@implementation WCDateComponents
@end

@implementation WCDateTool

#pragma mark - Get Current Date String

+ (nullable NSString *)stringFromCurrentDateWithFormat:(nullable NSString *)format {
    return [self stringFromDate:[NSDate date] format:format];
}

+ (nullable NSString *)stringFromDate:(NSDate *)date format:(nullable NSString *)format {
    if (![date isKindOfClass:[NSDate class]] || (format && ![format isKindOfClass:[NSString class]])) {
        return nil;
    }
    
    static NSDateFormatter *sDateFormatter;
    if (!sDateFormatter) {
        sDateFormatter = [[NSDateFormatter alloc] init];
        sDateFormatter.timeZone = [NSTimeZone systemTimeZone];
    }
    
    sDateFormatter.dateFormat = format.length ? format : @"yyyy-MM-dd HH:mm:ss ZZ";
    
    return [sDateFormatter stringFromDate:date];
}

#pragma mark - Date Components

#pragma mark > Get components of date

+ (nullable WCDateComponents *)dateComponentsWithDate:(nullable NSDate *)date {
    if (date && ![date isKindOfClass:[NSDate class]]) {
        return nil;
    }
    
    if (date == nil) {
        date = [NSDate date];
    }
    
    NSDateComponents *components = [[self currentCalendar] components:[self componentFlags] fromDate:date];
    
    WCDateComponents *newComponents = [WCDateComponents new];
    newComponents.date = date;
    newComponents.components = components;
    
    newComponents.year = components.year;
    newComponents.month = components.month;
    newComponents.weekOfYear = components.weekOfYear;
    newComponents.weekOfMonth = components.weekOfMonth;
    newComponents.day = components.day;
    newComponents.weekday = components.weekday;
    newComponents.hour = components.hour;
    newComponents.minute = components.minute;
    newComponents.second = components.second;
    newComponents.nthWeekday = components.weekdayOrdinal;
    newComponents.nearestHour = ({
        NSTimeInterval aTimeInterval = [date timeIntervalSinceReferenceDate] + 60 * 30;
        NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
        NSDateComponents *components = [[self currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
        
        components.hour;
    });
    
    return newComponents;
}

#pragma mark > Date components comparison

+ (BOOL)sameDateComponentWithDate:(NSDate *)date anotherDate:(NSDate *)anotherDate dateComponentType:(WCDateComponentType)dateComponentType {
    NSCalendarUnit unit = NSNotFound;
    switch (dateComponentType) {
        case WCDateComponentTypeYear:
            unit = NSCalendarUnitYear;
            break;
        case WCDateComponentTypeMonth:
            unit = NSCalendarUnitMonth;
            break;
        case WCDateComponentTypeDay:
            unit = NSCalendarUnitDay;
            break;
        case WCDateComponentTypeHour:
            unit = NSCalendarUnitHour;
            break;
        case WCDateComponentTypeMinute:
            unit = NSCalendarUnitMinute;
            break;
        case WCDateComponentTypeSecond:
            unit = NSCalendarUnitSecond;
            break;
        case WCDateComponentTypeWeekday:
            unit = NSCalendarUnitWeekday;
            break;
        case WCDateComponentTypeWeekOfMonth:
            unit = NSCalendarUnitWeekOfMonth;
            break;
        case WCDateComponentTypeWeekOfYear:
            unit = NSCalendarUnitWeekOfYear;
            break;
        default:
            break;
    }
    
    if (unit == NSNotFound) {
        return NO;
    }
    
    return [[self currentCalendar] isDate:date equalToDate:anotherDate toUnitGranularity:unit];
}

#pragma mark ::

+ (NSCalendar *)currentCalendar {
    static __strong NSCalendar *sharedCalendar = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    });
    
    return sharedCalendar;
}

/**
 *  Get all compoents of NSDate
 *
 *  @sa http://stackoverflow.com/questions/25952532/weekofyear-not-working
 *  @note must pass the correct flags to the components:fromDate: method
 *
 *  @return all components of NSDate
 */
+ (unsigned)componentFlags {
    static unsigned componentFlags;
    
    if (!componentFlags) {
        componentFlags = (NSCalendarUnitEra | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal | NSCalendarUnitQuarter  | NSCalendarUnitWeekOfMonth | NSCalendarUnitWeekOfYear);
    }
    
    return componentFlags;
}

#pragma mark ::

#pragma mark > Adjust date by components

+ (nullable NSDate *)dateWithDate:(NSDate *)date offset:(NSInteger)offset dateComponentType:(WCDateComponentType)dateComponentType {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    switch (dateComponentType) {
        case WCDateComponentTypeYear:
            dateComponents.year = offset;
            break;
        case WCDateComponentTypeMonth:
            dateComponents.month = offset;
            break;
        case WCDateComponentTypeDay:
            dateComponents.day = offset;
            break;
        case WCDateComponentTypeHour:
            dateComponents.hour = offset;
            break;
        case WCDateComponentTypeMinute:
            dateComponents.minute = offset;
            break;
        case WCDateComponentTypeSecond:
            dateComponents.second = offset;
            break;
        case WCDateComponentTypeWeekday:
            dateComponents.weekday = offset;
            break;
        case WCDateComponentTypeWeekOfMonth:
            dateComponents.weekOfMonth = offset;
            break;
        case WCDateComponentTypeWeekOfYear:
            dateComponents.weekdayOrdinal = offset;
            break;
        default:
            return nil;
    }
    
    NSDate *newDate = [[self currentCalendar] dateByAddingComponents:dateComponents toDate:date options:kNilOptions];
    return newDate;
}

@end
