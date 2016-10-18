//
//  UIView+Action.m
//  ZHFramework
//
//  Created by xzh. on 15/9/6.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "UIView+HZAction.h"
#import <objc/runtime.h>

static const char kBlock = '\0';
@implementation UIView (HZAction)

- (void)tapPeformBlock:(void(^)())block
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self addGestureRecognizer:tap];
    [self setBlock:block];
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    void(^voidBlock)() = [self block];
    if (voidBlock) {
        voidBlock();
    }
}

- (void)setBlock:(void(^)())block
{
    if (block) {
        objc_setAssociatedObject(self, &kBlock, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    }
}

- (void(^)())block
{
    return objc_getAssociatedObject(self, &kBlock);
}

@end
