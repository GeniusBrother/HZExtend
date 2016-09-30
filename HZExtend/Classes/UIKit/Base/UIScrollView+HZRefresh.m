//
//  UIScrollView+HZRefresh.m
//  HZNetworkDemo
//
//  Created by xzh on 16/1/19.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "UIScrollView+HZRefresh.h"

@implementation UIScrollView (HZRefresh)
- (void)addRefreshHeader:(MJRefreshHeader *)headerView
{
    self.mj_header = headerView;
}

- (void)addRefreshFooter:(MJRefreshFooter *)footerView
{
    self.mj_footer = footerView;
}

- (void)headerBeginRefreshing
{
    if (!self.mj_header.isRefreshing) {
        [self.mj_header beginRefreshing];
    }
}

- (void)footerBeginRefreshing
{
    if (!self.mj_footer.isRefreshing) {
        [self.mj_footer beginRefreshing];
    }
}

- (void)endAllRefreshWithExistMoreData:(BOOL)existMoreData
{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    
    if (!existMoreData) [self.mj_footer endRefreshingWithNoMoreData];
}

- (void)endFooterRefreshWithEnd:(NSInteger)isEnd
{
    [self.mj_footer endRefreshing];
    
    if (isEnd != 0) [self.mj_footer endRefreshingWithNoMoreData];
}
@end
