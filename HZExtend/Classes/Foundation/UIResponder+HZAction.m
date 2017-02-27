//
//  UIResponder+HZAction.m
//  Pods
//
//  Created by xzh on 2017/2/26.
//
//

#import "UIResponder+HZAction.h"

@implementation UIResponder (HZAction)

- (void)enumerateMethodResponserWithSelector:(SEL)selector usingBlock:(void (^)(UIResponder *))block
{
    UIResponder *next = [self nextResponder];
    do {
        if ([next respondsToSelector:selector]) {
            if (block) {
                block(next);
            }
        }
        next = [next nextResponder];
    } while (next != nil);
}

@end
