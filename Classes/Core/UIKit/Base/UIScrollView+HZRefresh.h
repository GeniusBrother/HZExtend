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

//增加刷新组件
- (void)addRefreshHeader:(MJRefreshHeader *)headerView;
- (void)addRefreshFooter:(MJRefreshFooter *)footerView;

//触发刷新
- (void)headerBeginRefreshing;
- (void)footerBeginRefreshing;

//结束刷新 1YES 0NO
- (void)endAllRefreshWithFooterEnd:(NSInteger)isEnd;
- (void)endFooterRefreshWithEnd:(NSInteger)isEnd;
@end
