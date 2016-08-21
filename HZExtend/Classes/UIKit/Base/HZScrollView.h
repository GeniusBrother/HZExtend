//
//  HZScrollView.h
//  HZNetworkDemo
//
//  Created by xzh on 16/3/27.
//  Copyright © 2016年 xzh. All rights reserved.
//


#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HZScrollViewScrollDirection) {
    HZScrollViewScrollDirectionNone,    //滚动方向未知
    HZScrollViewScrollDirectionBack,    //往回滚
    HZScrollViewScrollDirectionGo,      //往前滚
    HZScrollViewScrollDirectionBeyond   //回滚超出滚动范围
};

typedef NS_ENUM(NSInteger, HZScrollViewContentExpand) {
    HZScrollViewContentExpandVertical,    //内容在竖直方向扩张
    HZScrollViewContentExpandHorizontal,  //内容在水平方向上扩张
};

@class HZScrollView;
@protocol HZScrollViewDelegate<NSObject>

@optional
/**
 *  开始滚动时调用
 */
- (void)scrollViewBegainDrag:(HZScrollView *)scrollView;

/**
 *  滚动过程中不断调用
 *  offset即contentOffset
 */
- (void)scrollView:(HZScrollView *)scrollView scrollToOffset:(CGPoint)offset percentage:(CGFloat)per;

/**
 *  开始减速时调用
 */
- (void)scrollViewBegainDecelerate:(HZScrollView *)scrollView;

/**
 *  停止滚动时调用
 */
- (void)scrollViewStopScroll:(HZScrollView *)scrollView;

/**
 *  仅在支持分页模式,且页数改变时调用
 */
- (void)scrollView:(HZScrollView *)scrollView changeToPage:(NSUInteger)newPage;

/**
 *  仅当滚动方向改变时调用
 */
- (void)scrollView:(HZScrollView *)scrollView scrollDirectionDidChange:(HZScrollViewScrollDirection)directon;

@end

@interface HZScrollView : UIScrollView

@property(nonatomic, weak) id<HZScrollViewDelegate> scrollDelegate;

/**
 *  初始值为-1,页数从0开始计数,若pagingEnabled = NO,则永远为-1
 */
@property(nonatomic, assign, readonly) NSInteger currentPage;

/**
 *  滚动方向,主要分为往前滚还是往回滚
 */
@property(nonatomic, assign, readonly) HZScrollViewScrollDirection scrollDirection;

/**
 *  需初始化指定,默认为HZScrollViewContentExpandVertical
 */
@property(nonatomic, assign, readonly) HZScrollViewContentExpand contentExpand;

- (instancetype)initWithFrame:(CGRect)frame
                contentExpand:(HZScrollViewContentExpand)contentExpand
                     delegate:(id<HZScrollViewDelegate>)scrollDelegate;

- (instancetype)initWithFrame:(CGRect)frame NS_UNAVAILABLE;

@end
