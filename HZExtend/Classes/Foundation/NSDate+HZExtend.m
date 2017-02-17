//
//  NSDate+HZExtend.m
//  Pods
//
//  Created by xzh on 2017/2/17.
//
//

#import "NSDate+HZExtend.h"

@implementation NSDate (HZExtend)

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

- (BOOL)isInThisYear
{
    NSDateComponents *nowComponents = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:[NSDate date]];
    NSDateComponents *selfComponents = [CURRENT_CALENDAR components:NSCalendarUnitYear fromDate:self];
    
    return nowComponents.year == selfComponents.year;
}

@end
