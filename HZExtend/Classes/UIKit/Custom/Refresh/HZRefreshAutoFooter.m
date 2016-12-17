//
//  HZRefreshAutoFooter.m
//  HZNetworkDemo
//
//  Created by xzh on 16/1/20.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZRefreshAutoFooter.h"
#import "HZCircleView.h"
#import "UIView+HZExtend.h"
#import "UIColor+HZExtend.h"
#import "HZMacro.h"
@interface HZRefreshAutoFooter ()

@property(nonatomic, weak) HZCircleView *circleView;
@property(nonatomic, weak) UILabel *noDataLabel;
@end

@implementation HZRefreshAutoFooter


#pragma mark - 重写方法
#pragma mark 在这里做一些初始化配置（比如添加子控件）
- (void)prepare
{
    [super prepare];
    
    // 设置控件的高度
    self.mj_h = 60;
    
    HZCircleView *circleView = [[HZCircleView alloc] init];
    [self addSubview:circleView];
    self.circleView = circleView;
    
//    UILabel *noDataLabel = [[UILabel alloc] initWithFrame:CGRectZero];
//    noDataLabel.text = @"已经全部加载完毕";
//    noDataLabel.textColor = HZRGB(90, 90, 90);
//    noDataLabel.textAlignment = NSTextAlignmentCenter;
//    noDataLabel.font = [UIFont boldSystemFontOfSize:14];
//    noDataLabel.backgroundColor = [UIColor clearColor];
//    noDataLabel.hidden = YES;
//    [self addSubview:noDataLabel];
//    self.noDataLabel = noDataLabel;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.circleView.mj_size = CGSizeMake(30, 30);
    [self.circleView alignCenter];
    
    self.noDataLabel.frame = self.bounds;
}

#pragma mark 监听scrollView的contentOffset改变
- (void)scrollViewContentOffsetDidChange:(NSDictionary *)change
{
    [super scrollViewContentOffsetDidChange:change];
    
}

#pragma mark 监听scrollView的contentSize改变
- (void)scrollViewContentSizeDidChange:(NSDictionary *)change
{
    [super scrollViewContentSizeDidChange:change];
    
}

#pragma mark 监听scrollView的拖拽状态改变
- (void)scrollViewPanStateDidChange:(NSDictionary *)change
{
    [super scrollViewPanStateDidChange:change];
    
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateNoMoreData:      /** 无更多数据*/
            self.noDataLabel.hidden = NO;
            break;
        case MJRefreshStateIdle:            /** 普通闲置状态 */
            self.noDataLabel.hidden = YES;
            
            self.circleView.progress = 0;
            [self.circleView setNeedsDisplay];
            [self.circleView.layer removeAnimationForKey:@"rotateAnimation"];
            
            break;
        case MJRefreshStatePulling:         /** 松开就可以进行刷新的状态 */
            self.circleView.progress = 1;
            [self.circleView setNeedsDisplay];
            break;
        case MJRefreshStateWillRefresh:
            break;
        case MJRefreshStateRefreshing:      /** 正在刷新中的状态 */
            self.circleView.progress = 1;
            [self.circleView setNeedsDisplay];
            [CATransaction begin];
            [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
            [CATransaction commit];
            CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath: @"transform.rotation.z"];
            rotate.removedOnCompletion = FALSE;
            rotate.fillMode = kCAFillModeForwards;
            [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
            rotate.repeatCount = HUGE_VALF;
            rotate.duration = 0.25;
            rotate.cumulative = TRUE;
            rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
            [self.circleView.layer addAnimation:rotate forKey:@"rotateAnimation"];
            break;
    }
}

@end
