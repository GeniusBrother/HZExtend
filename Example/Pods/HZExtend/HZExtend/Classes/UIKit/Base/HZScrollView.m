//
//  HZScrollView.m
//  HZNetworkDemo
//
//  Created by xzh on 16/3/27.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZScrollView.h"
#import "UIView+HZExtend.h"
#import "UIScrollView+HZExtend.h"
@interface HZScrollView ()<UIScrollViewDelegate>

@property(nonatomic, assign) NSInteger currentPage;
@property(nonatomic, assign) HZScrollViewScrollDirection scrollDirection;
@property(nonatomic, assign) HZScrollViewContentExpand contentExpand;

@property(nonatomic, assign) CGFloat lastContentOffsetDistance;
@end

@implementation HZScrollView

#pragma mark - Init
- (instancetype)initWithFrame:(CGRect)frame
                contentExpand:(HZScrollViewContentExpand)contentExpand
                     delegate:(id<HZScrollViewDelegate>)scrollDelegate
{
    self = [super initWithFrame:frame];//不会调用init
    if (self) {
        _contentExpand = contentExpand;
        _scrollDelegate = scrollDelegate;
        
        [self setup];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _contentExpand = HZScrollViewContentExpandVertical;
        [self setup];
    }
    return self;
}

/**
 *  初始化配置
 */
- (void)setup
{
    self.delegate = self;
    
    _currentPage = -1;
    
    _scrollDirection = HZScrollViewScrollDirectionNone;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewBegainDrag:)]) {
        [self.scrollDelegate scrollViewBegainDrag:(HZScrollView *)scrollView];
    }
}

/**
 *  回调滚动offset和百分比、滚动方向
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //滚动offset和百分比
    [self scrollingForScrollView:scrollView];
    
    //滚动方向
    [self scrollDirectionChangeForScrollView:scrollView];

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) return;
        
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewBegainDecelerate:)]) {
        [self.scrollDelegate scrollViewBegainDecelerate:(HZScrollView *)scrollView];
    }
}

/**
 *  回调滚动比例和页数改变
 */
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollingForScrollView:scrollView];
    
    BOOL isHorizontalExpand = [self isHorizontalExpand];
    CGFloat pageDistance = isHorizontalExpand?scrollView.width:scrollView.height;
    CGFloat scrollDistance = isHorizontalExpand?scrollView.offsetX:scrollView.offsetY;
    NSUInteger page = scrollDistance/pageDistance;
    self.currentPage = page;
    
    if ([self.scrollDelegate respondsToSelector:@selector(scrollViewStopScroll:)]) {
        [self.scrollDelegate scrollViewStopScroll:(HZScrollView *)scrollView];
    }
}

#pragma mark - Private Method
- (BOOL)isHorizontalExpand
{
    return HZScrollViewContentExpandHorizontal == self.contentExpand;
}

- (void)scrollingForScrollView:(UIScrollView *)scrollView
{
    BOOL isHorizontalExpand = [self isHorizontalExpand];
    CGFloat totalDistance = isHorizontalExpand?(scrollView.contentWidth-scrollView.width):(scrollView.contentHeight - scrollView.contentHeight);
    CGFloat scrollDistance = isHorizontalExpand?scrollView.offsetX:scrollView.offsetY;
    
    if ([self.scrollDelegate respondsToSelector:@selector(scrollView:scrollToOffset:percentage:)]) {
        [self.scrollDelegate scrollView:(HZScrollView *)scrollView scrollToOffset:scrollView.contentOffset percentage:scrollDistance/totalDistance];
    }
}

- (void)scrollDirectionChangeForScrollView:(UIScrollView *)scrollView
{
    CGFloat offsetDistance = [self isHorizontalExpand]?scrollView.offsetX:scrollView.offsetY;
    
    if (offsetDistance > 0) {        
        if (offsetDistance > self.lastContentOffsetDistance && self.scrollDirection != HZScrollViewScrollDirectionGo) {  //go
            
            [self scrollDirectionDidChange:HZScrollViewScrollDirectionGo];
        }else if (offsetDistance < self.lastContentOffsetDistance  && self.scrollDirection != HZScrollViewScrollDirectionBack) {  //back
            [self scrollDirectionDidChange:HZScrollViewScrollDirectionBack];
        }
                  
    }else {  //往负方向时不管向上还是向下都要一直显示
        if (self.lastContentOffsetDistance >= 0) {  //只调用一次
            [self scrollDirectionDidChange:HZScrollViewScrollDirectionBeyond];
        }
    }

    self.lastContentOffsetDistance = offsetDistance;
}

- (void)scrollDirectionDidChange:(HZScrollViewScrollDirection)direction
{
    self.scrollDirection = direction;
    if ([self.scrollDelegate respondsToSelector:@selector(scrollView:scrollDirectionDidChange:)]) {
        [self.scrollDelegate scrollView:self scrollDirectionDidChange:direction];
    }
}

+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if([key isEqualToString:@"currentPage"]) return NO;
    return [super automaticallyNotifiesObserversForKey:key];
}

- (void)setCurrentPage:(NSInteger)currentPage
{
    if (currentPage != _currentPage) {
        [self willChangeValueForKey:@"currentPage"];
        _currentPage = currentPage;
        [self didChangeValueForKey:@"currentPage"];
        
        if (!self.pagingEnabled) return;
        
        if ([self.scrollDelegate respondsToSelector:@selector(scrollView:changeToPage:)]) {
            [self.scrollDelegate scrollView:self changeToPage:_currentPage];
        }
    }
    
}
@end
