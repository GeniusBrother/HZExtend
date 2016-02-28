//
//  HZURLManageConfig.h
//  HZNetworkDemo
//
//  Created by xzh on 16/2/27.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
/**
 *  URLManager中的数据配置器
 */
@interface HZURLManageConfig : NSObject
singleton_h(Config)
/**
 *  URL->class配置参数,键值对形式为: URL:Class of UIViewController
 *  需先初始化
 */
@property(nonatomic, strong) NSDictionary *config;

/**
 *  指定传入http等URL时应生成控制器的名称,最好能继承HZWebViewController
 */
@property(nonatomic, strong) NSString *classOfWebViewCtrl;

@end
