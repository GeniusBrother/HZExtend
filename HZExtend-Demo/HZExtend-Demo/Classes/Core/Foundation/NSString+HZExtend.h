//
//  NSString+HZExtend.h
//  ZHFramework
//
//  Created by xzh. on 15/7/20.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"
@interface NSString (HZExtend)

- (NSString *)md5;

/************查询字符串************/
- (NSString *)urlEncode;
- (NSString *)urlDecode;
- (NSString *)schema;
- (NSString *)host;
- (NSString *)allPath;
- (NSString *)path;
- (NSString *)keyValues;
- (NSDictionary *)queryDic;

@end
