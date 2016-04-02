//
//  UIScrollView+HZRefresh.h
//  HZNetworkDemo
//
//  Created by xzh on 16/1/19.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZRefreshHeaderView.h"
#import "HZRefreshBackFooter.h"
#import "HZRefreshAutoFooter.h"
@interface UIScrollView (HZRefresh)

/**
 *  1.创建刷新控件并指定回调
 */
- (void)addRefreshHeader:(MJRefreshHeader *)headerView; //下拉刷新控件
- (void)addRefreshFooter:(MJRefreshFooter *)footerView; //上拉加载控件

/**
 *  2.触发回调
 */
- (void)headerBeginRefreshing;
- (void)footerBeginRefreshing;

/**
 *  3.结束全部刷新,并指定是否有更多数据
 *  isEnd:1YES 0NO
 */
- (void)endAllRefreshWithFooterEnd:(NSInteger)isEnd;

@end
