//
//  UIResponder+HZExtend.m
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 17/2/26.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import "UIResponder+HZExtend.h"

@implementation UIResponder (HZAction)

- (void)deliveryMessageWithSelector:(SEL)selector usingBlock:(void (^)(UIResponder * _Nonnull))block
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
