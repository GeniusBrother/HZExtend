//
//  UIViewController+PageView.m
//  Test
//
//  Created by xzh on 2016/12/5.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "UIViewController+PageView.h"
#import <objc/runtime.h>
static const char kPageKey = '\0';
static const char kChapterKey = '\0';
@implementation UIViewController (PageView)

- (void)setPage:(NSInteger)page
{
    NSNumber *pageNumber = objc_getAssociatedObject(self, &kPageKey);
    if ([pageNumber integerValue] != page) {
        [self willChangeValueForKey:@"page"];
        objc_setAssociatedObject(self, &kPageKey, @(page), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"page"];
    }
}

- (NSInteger)page
{
    NSNumber *pageNumber = objc_getAssociatedObject(self, &kPageKey);
    return [pageNumber integerValue];
}

- (void)setChapter:(NSInteger)chapter
{
    NSNumber *chapterNumber = objc_getAssociatedObject(self, &kChapterKey);
    if ([chapterNumber integerValue] != chapter) {
        [self willChangeValueForKey:@"chapter"];
        objc_setAssociatedObject(self, &kChapterKey, @(chapter), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"chapter"];
    }
}

- (NSInteger)chapter
{
    NSNumber *chapterNumber = objc_getAssociatedObject(self, &kChapterKey);
    return [chapterNumber integerValue];
}

@end
