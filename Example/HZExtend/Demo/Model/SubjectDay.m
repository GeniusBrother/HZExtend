//
//  SubjectDay.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "SubjectDay.h"

@implementation SubjectDay
+ (void)initialize {
    if ([SubjectDay self] == self) {
        [SubjectDay mj_setupObjectClassInArray:^NSDictionary *{
            return @{@"items":@"SubjectItem"};
        }];
        
    }
}

@end
