//
//  NSDate+HZExtend.h
//  Pods
//
//  Created by xzh on 2017/2/17.
//
//

#import <Foundation/Foundation.h>
//yyyy-MM-dd HH:mm:ss
#define CURRENT_CALENDAR [NSCalendar currentCalendar]
NS_ASSUME_NONNULL_BEGIN

@interface NSDate (HZExtend)

//判断date是否为今天之内
- (BOOL)isInToday;

//判断date是否为昨天之内
- (BOOL)isInYesterday;

//判断date是否为明天之内
- (BOOL)isInTomorrow;

//判断date是否为今年之内
- (BOOL)isInThisYear;

@end

NS_ASSUME_NONNULL_END
