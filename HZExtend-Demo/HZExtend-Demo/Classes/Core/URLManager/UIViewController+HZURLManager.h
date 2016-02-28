//
//  UIViewController+HZURLManager.h
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZURLManageConfig.h"
/**
 *  根据URL生成控制器
 */
@interface UIViewController (HZURLManager)

/**
 *  传入URL来生成对应的控制器,可以作为页面的标识
 */
@property(nonatomic, strong, readonly) NSString *originURL;

/**
 *  由查询字符串和queryDic组成
 */
@property(nonatomic, strong, readonly) NSDictionary *queryDic;

/**
 *  根据URL(schema://abc?k=v)获得对应的控制器
 *  queryDic到时候可通过控制器的queryDic属性获得
 */
+ (UIViewController *)viewControllerWithString:(NSString *)urlstring;
+ (UIViewController *)viewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)queryDic;

@end
