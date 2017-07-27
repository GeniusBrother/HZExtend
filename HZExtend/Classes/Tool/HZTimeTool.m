//
//  HZTimeTool.m
//  Pods
//
//  Created by xzh on 2017/2/17.
//
//

#import "HZTimeTool.h"
#import "NSDate+HZExtend.h"
@implementation HZTimeTool

+ (long long)getFirstDayOfWeek:(NSTimeInterval)timestamp
{
    NSDate *now = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSDateComponents *comps = [CURRENT_CALENDAR components:NSCalendarUnitWeekday fromDate:now];
    if (comps.weekday == 1) {
        return timestamp - 6*24*60*60;
    }else {
        return timestamp - (comps.weekday - 2)*24*60*60;
    }
}
@end
