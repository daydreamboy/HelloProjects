//
//  WCDateTool.m
//  HelloNSDate
//
//  Created by wesley_chen on 2019/4/9.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCDateTool.h"

// >= `8.0`
#ifndef IOS8_OR_LATER
#define IOS8_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"8.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

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
    
    newComponents.era = components.era;
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

#pragma mark > Date components compare with now

+ (BOOL)isTheDayAfterTomorrowWithDate:(NSDate *)date {
    // @see https://github.com/erica/NSDate-Extensions/blob/master/NSDate%2BUtilities.m#L149
    NSDate *theDayAfterTomorrow = [self dateTheDayAfterTomorrow];
    WCDateComponents *components1 = [self dateComponentsWithDate:theDayAfterTomorrow];
    WCDateComponents *components2 = [self dateComponentsWithDate:date];
    
    if (components1.era == components2.era && components1.year == components2.year && components1.month == components2.month && components1.day == components2.day) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isTomorrowWithDate:(NSDate *)date {
    return [[self currentCalendar] isDateInTomorrow:date];
}

+ (BOOL)isTodayWithDate:(NSDate *)date {
    return [[self currentCalendar] isDateInToday:date];
}

+ (BOOL)isYesterdayWithDate:(NSDate *)date {
    return [[self currentCalendar] isDateInYesterday:date];
}

+ (BOOL)isTheDayBeforeYesterdayWithDate:(NSDate *)date {
    NSDate *theDayBeforeYesterday = [self dateTheDayBeforeYesterday];
    WCDateComponents *components1 = [self dateComponentsWithDate:theDayBeforeYesterday];
    WCDateComponents *components2 = [self dateComponentsWithDate:date];
    
    if (components1.era == components2.era && components1.year == components2.year && components1.month == components2.month && components1.day == components2.day) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isNextYearWithDate:(NSDate *)date {
    NSDate *nextYear = [self dateNextYear];
    WCDateComponents *components1 = [self dateComponentsWithDate:nextYear];
    WCDateComponents *components2 = [self dateComponentsWithDate:date];
    
    if (components1.era == components2.era && components1.year == components2.year) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isThisYearWithDate:(NSDate *)date {
    NSDate *thisYear = [NSDate date];
    WCDateComponents *components1 = [self dateComponentsWithDate:thisYear];
    WCDateComponents *components2 = [self dateComponentsWithDate:date];
    
    if (components1.era == components2.era && components1.year == components2.year) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)isLastYearWithDate:(NSDate *)date {
    NSDate *lastYear = [self dateLastYear];
    WCDateComponents *components1 = [self dateComponentsWithDate:lastYear];
    WCDateComponents *components2 = [self dateComponentsWithDate:date];
    
    if (components1.era == components2.era && components1.year == components2.year) {
        return YES;
    }
    
    return NO;
}

+ (NSInteger)offsetByNowWithDate:(NSDate *)date dateComponentType:(WCDateComponentType)dateComponentType {
    if (![date isKindOfClass:[NSDate class]]) {
        return NSNotFound;
    }
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [[self currentCalendar] components:(NSCalendarUnit)dateComponentType fromDate:now toDate:date options:kNilOptions];
    switch (dateComponentType) {
        case WCDateComponentTypeYear:
            return components.year;
        case WCDateComponentTypeMonth:
            return components.month;
        case WCDateComponentTypeDay:
            return components.day;
        case WCDateComponentTypeHour:
            return components.hour;
        case WCDateComponentTypeMinute:
            return components.minute;
        case WCDateComponentTypeSecond:
            return components.second;
        case WCDateComponentTypeWeekday:
            return components.weekday;
        case WCDateComponentTypeWeekOfMonth:
            return components.weekOfMonth;
        case WCDateComponentTypeWeekOfYear:
            return components.weekOfYear;
        default:
            break;
    }
    
    return NSNotFound;
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

#pragma mark >> Day

+ (NSDate *)dateTheDayAfterTomorrow {
    return [self dateWithDate:[NSDate date] offset:2 dateComponentType:WCDateComponentTypeDay];
}

+ (NSDate *)dateTomorrow {
    return [self dateWithDate:[NSDate date] offset:1 dateComponentType:WCDateComponentTypeDay];
}

+ (NSDate *)dateToday {
    return [self dateWithDate:[NSDate date] offset:0 dateComponentType:WCDateComponentTypeDay];
}

+ (NSDate *)dateYesterday {
    return [self dateWithDate:[NSDate date] offset:-1 dateComponentType:WCDateComponentTypeDay];
}

+ (NSDate *)dateTheDayBeforeYesterday {
    return [self dateWithDate:[NSDate date] offset:-2 dateComponentType:WCDateComponentTypeDay];
}

#pragma mark >> Year

+ (NSDate *)dateNextYear {
    return [self dateWithDate:[NSDate date] offset:1 dateComponentType:WCDateComponentTypeYear];
}

+ (NSDate *)dateLastYear {
    return [self dateWithDate:[NSDate date] offset:-1 dateComponentType:WCDateComponentTypeYear];
}

+ (nullable NSDate *)dateWithDate:(NSDate *)date offset:(NSInteger)offset dateComponentType:(WCDateComponentType)dateComponentType {
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    
    switch (dateComponentType) {
        case WCDateComponentTypeEra:
            dateComponents.era = offset;
            break;
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
