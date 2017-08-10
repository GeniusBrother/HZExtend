//
//  NSDate+HZExtend.m
//  Pods
//
//  Created by xzh on 2017/2/17.
//
//

#import "NSDate+HZExtend.h"
#import "NSObject+HZExtend.h"
@implementation NSDate (HZExtend)

#pragma mark - Properties
#define DATE_COMPONENT(_type_, _conponent_) [[[NSCalendar currentCalendar] components:_type_ fromDate:self] _conponent_]
- (NSInteger)year { return DATE_COMPONENT(NSCalendarUnitYear, year); }
- (NSInteger)month { return DATE_COMPONENT(NSCalendarUnitMonth, month); }
- (NSInteger)hour{ return DATE_COMPONENT(NSCalendarUnitHour, hour); }
- (NSInteger)day{ return DATE_COMPONENT(NSCalendarUnitDay, day); }
- (NSInteger)minute{ return DATE_COMPONENT(NSCalendarUnitMinute, minute); }
- (NSInteger)second{ return DATE_COMPONENT(NSCalendarUnitSecond, second); }
- (NSInteger)nanosecond{ return DATE_COMPONENT(NSCalendarUnitNanosecond, nanosecond); }
- (NSInteger)weekday{ return DATE_COMPONENT(NSCalendarUnitNanosecond, nanosecond);}
- (NSInteger)weekdayOrdinal{ return DATE_COMPONENT(NSCalendarUnitNanosecond, nanosecond); }
- (NSInteger)weekOfYear{ return DATE_COMPONENT(NSCalendarUnitNanosecond, nanosecond); }
- (NSInteger)weekOfMonth{ return DATE_COMPONENT(NSCalendarUnitWeekOfMonth, weekOfMonth); }
- (NSInteger)yearForWeekOfYear{ return DATE_COMPONENT(NSCalendarUnitYearForWeekOfYear, yearForWeekOfYear);}
- (NSInteger)quarter{ return DATE_COMPONENT(NSCalendarUnitQuarter, quarter); }
- (BOOL)isLeapMonth{ return DATE_COMPONENT(NSCalendarUnitMonth, isLeapMonth); }
- (BOOL)isLeapYear
{
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}


- (NSUInteger)timeStamp
{
    return (NSUInteger)self.timeIntervalSince1970;
}

#pragma mark - Date modify
- (NSDate *)dateByAddingYears:(NSInteger)years {
    NSCalendar *calendar =  [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setYear:years];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingMonths:(NSInteger)months {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setMonth:months];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingWeeks:(NSInteger)weeks {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setWeekOfYear:weeks];
    return [calendar dateByAddingComponents:components toDate:self options:0];
}

- (NSDate *)dateByAddingDays:(NSInteger)days {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 86400 * days;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingHours:(NSInteger)hours {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 3600 * hours;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingMinutes:(NSInteger)minutes {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + 60 * minutes;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds {
    NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + seconds;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    return newDate;
}

#pragma mark Range
- (BOOL)isInToday
{
    return [CURRENT_CALENDAR isDateInToday:self];
}

- (BOOL)isInTomorrow
{
    return [CURRENT_CALENDAR isDateInTomorrow:self];
}

- (BOOL)isInYesterday
{
    return [CURRENT_CALENDAR isDateInYesterday:self];
}

- (BOOL)isInThisMonth
{
    NSDateComponents *nowComponents = [CURRENT_CALENDAR components:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [CURRENT_CALENDAR components:NSCalendarUnitMonth fromDate:self];
    return nowComponents.month == selfComponents.month;
}

- (BOOL)isInThisWeek
{
    NSDateComponents *nowComponents = [CURRENT_CALENDAR components:NSCalendarUnitWeekOfYear fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [CURRENT_CALENDAR components:NSCalendarUnitWeekOfYear fromDate:self];
    return nowComponents.weekOfYear == selfComponents.weekOfYear;
}

- (BOOL)isInThisYear
{
    NSDateComponents *nowComponents = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    
    return nowComponents.year == selfComponents.year;
}

#pragma mark Convert
+ (NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:dateString];
}

- (NSString *)formatDateWithSeparator:(NSString *)separator
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"yyyy%@MM%@dd",separator,separator]];
    return [formatter stringFromDate:self];
}

- (NSString *)formatTimeWithSeparator:(NSString *)separator
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:[NSString stringWithFormat:@"HH%@mm",separator]];
    return [formatter stringFromDate:self];
}

+ (NSUInteger)timeStamp
{
    return [[[NSDate alloc] init] timeStamp];
}


@end
