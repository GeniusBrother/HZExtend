//
//  UIViewController+HZExtend.m
//  mcapp
//
//  Created by xzh on 2016/11/20.
//  Copyright © 2016年 发条橙. All rights reserved.
//

#import "UIViewController+HZExtend.h"
#import <objc/runtime.h>
static const char kDoneKey = '\0';

@implementation UIViewController (HZExtend)

- (void)performTask:(void (^)(BOOL done))block
{
    if (block) {
        block([self done]);
    }
    [self setDone:YES];
}

- (BOOL)done
{
    NSNumber *first = objc_getAssociatedObject(self, &kDoneKey);
    return [first boolValue];
}

- (void)setDone:(BOOL)Done
{
    [self willChangeValueForKey:@"done"];
    objc_setAssociatedObject(self, &kDoneKey, @(Done), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"done"];
}

@end
