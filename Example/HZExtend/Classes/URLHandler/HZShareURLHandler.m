//
//  HZShareURLHandler.m
//  HZExtend
//
//  Created by xzh on 2017/7/28.
//  Copyright © 2017年 GeniusBrother. All rights reserved.
//

#import "HZShareURLHandler.h"
#import <HZExtend/HZExtend.h>

@interface HZShareURLHandler ()<HZURLHandler>


@end

@implementation HZShareURLHandler

/**
 *  shareKit.hz/doShare
 *
 *  @param url
 *  
 *  @return nil
 */
- (id)handleURL:(NSURL *)url withTarget:(id)target withParams:(id)params
{
    NSDictionary *query = url.queryDic;
    [query enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@ %@",key,obj);
    }];
    return @"123";
}

@end
