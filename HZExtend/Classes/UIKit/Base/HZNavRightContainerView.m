//
//  HZNavRightContainerView.m
//  Pods
//
//  Created by xzh on 2017/2/28.
//
//

#import "HZNavRightContainerView.h"
#import "UIView+HZExtend.h"
@interface HZNavRightContainerView ()

@end

@implementation HZNavRightContainerView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *subView = [self.subviews firstObject];
    
    CGFloat right = self.right;
    self.width = subView.left + subView.width;
    self.left = right - self.width;
}
@end
