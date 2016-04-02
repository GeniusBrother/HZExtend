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
 *  URL配置
 *  URL的Host->class即 URL的host:Class of UIViewController
 */
@property(nonatomic, strong) NSDictionary *config;

/**
 *  指定传入http等URL时应生成控制器的名称,最好能继承HZWebViewController
 */
@property(nonatomic, strong) NSString *classOfWebViewCtrl;

/**
 *  使用URLManager跳转时，指定下bar是否隐藏,默认NO
 */
@property(nonatomic, assign) BOOL hideBottomWhenPushed;

@end
