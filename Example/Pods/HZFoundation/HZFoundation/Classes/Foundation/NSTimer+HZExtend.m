//
//  NSTimer+HZExtend.m
//  Pods
//
//  Created by xzh on 2017/8/4.
//
//

#import "NSTimer+HZExtend.h"

@implementation NSTimer (HZExtend)

+ (void)fire:(NSTimer *)timer
{
    if ([timer userInfo]) {
        void (^block)(NSTimer *timer) = (void (^)(NSTimer *timer))[timer userInfo];
        block(timer);
    }
}

+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer * _Nonnull))block repeats:(BOOL)repeats
{
    return [NSTimer scheduledTimerWithTimeInterval:seconds target:self selector:@selector(fire:) userInfo:[block copy] repeats:repeats];
}

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)seconds block:(void (^)(NSTimer *timer))block repeats:(BOOL)repeats
{
    return [NSTimer timerWithTimeInterval:seconds target:self selector:@selector(fire:) userInfo:[block copy] repeats:repeats];
}


@end
