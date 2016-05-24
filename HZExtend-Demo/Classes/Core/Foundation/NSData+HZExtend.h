//
//  NSData+HzExtend.h
//  ZHFramework
//
//  Created by xzh. on 15/7/26.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSObject+HZExtend.h"

NS_ASSUME_NONNULL_BEGIN
@interface NSData (HZExtend)

/**
 *  返回该二进制数据的二进制格式md5编码
 */
- (NSData *)md5;

/**
 *  返回该二进制数据的字符串格式md5编码
 */
- (NSString *)md5String;

@end
NS_ASSUME_NONNULL_END