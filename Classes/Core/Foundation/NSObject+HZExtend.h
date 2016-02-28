//
//  NSObject+HzExtend.h
//  ZHFramework
//
//  Created by xzh. on 15/7/26.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (HZExtend)
/**
 *  判断为非空,既非NSNull且长度(字符串)或者count(集合)>0
 */
- (BOOL)isNoEmpty;

@end
