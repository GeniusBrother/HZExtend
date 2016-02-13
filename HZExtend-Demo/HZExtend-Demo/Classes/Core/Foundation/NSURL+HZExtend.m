//
//  NSURL+HZExtend.m
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "NSURL+HZExtend.h"
#import "NSObject+HZExtend.h"
#import "NSString+HZExtend.h"
@implementation NSURL (HZExtend)

- (NSDictionary *)queryDic
{
    return [self.absoluteString queryDic];
}


@end
