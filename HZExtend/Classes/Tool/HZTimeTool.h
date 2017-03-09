//
//  HZTimeTool.h
//  Pods
//
//  Created by xzh on 2017/2/17.
//
//
//yyyy-MM-dd HH:mm:ss
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZTimeTool : NSObject

/**
 *	获取时间戳所在周的第一天时间戳
 */
+ (long long)getFirstDayOfWeek:(long long)timestamp;

@end

NS_ASSUME_NONNULL_END
