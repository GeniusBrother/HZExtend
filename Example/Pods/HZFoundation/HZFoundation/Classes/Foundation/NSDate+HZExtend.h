//
//  NSDate+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 2017/2/17.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//
#import <Foundation/Foundation.h>

#define CURRENT_CALENDAR [NSCalendar currentCalendar]

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (HZExtend)

#pragma mark - Properties
///=============================================================================
/// @name Properties
///=============================================================================

/** The number of timestamp for the receiver. */
@property(nonatomic, readonly) NSUInteger timeStamp;

/** The number of Year units for the receiver. */
@property (nonatomic, readonly) NSInteger year;

/** The number of Month units for the receiver (1~12). */
@property (nonatomic, readonly) NSInteger month;

/** The number of Day units for the receiver (1~31). */
@property (nonatomic, readonly) NSInteger day;

/** The number of Hour units for the receiver (0~23). */
@property (nonatomic, readonly) NSInteger hour;

/** The number of Minute units for the receiver (0~59). */
@property (nonatomic, readonly) NSInteger minute;

/** The number of Second units for the receiver (0~59). */
@property (nonatomic, readonly) NSInteger second;

/** The number of Nanosecond units for the receiver (0~999). */
@property (nonatomic, readonly) NSInteger nanosecond;

/** The number of Weekday units for the receiver (1~7, first day is based on user setting). */
@property (nonatomic, readonly) NSInteger weekday;

/** The ordinal number of weekday units for the receiver (1~5). */
@property (nonatomic, readonly) NSInteger weekdayOrdinal;

/** The week number of the month for the receiver (1~5). */
@property (nonatomic, readonly) NSInteger weekOfMonth;

/** The week number of the year for the receiver (1~53). */
@property (nonatomic, readonly) NSInteger weekOfYear;

/** The ISO 8601 week-numbering year of the receiver. */
@property (nonatomic, readonly) NSInteger yearForWeekOfYear;

/** The number of quarters for the receiver. */
@property (nonatomic, readonly) NSInteger quarter;

/** Boolean value that indicates whether the month is a leap month. */
@property (nonatomic, readonly) BOOL isLeapMonth;

/** Boolean value that indicates whether the month is a leap year. */
@property (nonatomic, readonly) BOOL isLeapYear;


#pragma mark - Date modify
///=============================================================================
/// @name Date modify
///=============================================================================

/**
 Returns a date representing the receiver date shifted later by the provided number of seconds.
 
 @param seconds  Number of seconds to add.
 */
- (nullable NSDate *)dateByAddingSeconds:(NSInteger)seconds;

/**
 Returns a date representing the receiver date shifted later by the provided number of minutes.
 
 @param minutes  Number of minutes to add.
 */
- (nullable NSDate *)dateByAddingMinutes:(NSInteger)minutes;

/**
 Returns a date representing the receiver date shifted later by the provided number of hours.
 
 @param hours  Number of hours to add.
 */
- (nullable NSDate *)dateByAddingHours:(NSInteger)hours;

/**
 Returns a date representing the receiver date shifted later by the provided number of days.
 
 @param days  Number of days to add.
 */
- (nullable NSDate *)dateByAddingDays:(NSInteger)days;

/**
 Returns a date representing the receiver date shifted later by the provided number of weeks.
 
 @param weeks  Number of weeks to add.
 */
- (nullable NSDate *)dateByAddingWeeks:(NSInteger)weeks;

/**
 Returns a date representing the receiver date shifted later by the provided number of months.
 
 @param months  Number of months to add.
 */
- (nullable NSDate *)dateByAddingMonths:(NSInteger)months;

/**
 Returns a date representing the receiver date shifted later by the provided number of years.
 
 @param years  Number of years to add.
 */
- (nullable NSDate *)dateByAddingYears:(NSInteger)years;


#pragma mark - Convert
///=============================================================================
/// @name Convert
///=============================================================================

/**
 Returns a date parsed from given string interpreted using the format.
 
 @param dateString The string to parse.
 @param format     The string's date format.
 
 @return A date representation of string interpreted using the format.
 If can not parse the string, returns nil.
 */
+ (nullable NSDate *)dateWithString:(NSString *)dateString format:(NSString *)format;

/**
 Return a formate date string using the separator. e.g 2017-08-08
 */
- (NSString *)formatDateWithSeparator:(NSString *)separator;

/**
 Return a formate time string using the separator. e.g 08:08
 */
- (NSString *)formatTimeWithSeparator:(NSString *)separator;

/**
 Returns current timestamp
 */
+ (NSUInteger)timeStamp;

/**
 Return a Boolean value that indicates whether the data within today.
 */
- (BOOL)isInToday;

/**
 Return a Boolean value that indicates whether the data within yesterday.
 */
- (BOOL)isInYesterday;

/**
 Return a Boolean value that indicates whether the data within tomorrow.
 */
- (BOOL)isInTomorrow;

/**
 Return a Boolean value that indicates whether the data within current week.
 */
- (BOOL)isInThisWeek;

/**
 Return a Boolean value that indicates whether the data within current month.
 */
- (BOOL)isInThisMonth;

/**
 Return a Boolean value that indicates whether the data within current year.
 */
- (BOOL)isInThisYear;


@end

NS_ASSUME_NONNULL_END
