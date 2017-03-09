//
//  HZNavLeftContainerView.m
//  Pods
//
//  Created by xzh on 2017/2/28.
//
//

#import "HZNavLeftContainerView.h"
#import "UIView+HZExtend.h"
@interface HZNavLeftContainerView ()

@end

@implementation HZNavLeftContainerView

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    UIView *subView = [self.subviews firstObject];
    self.width = self.left + subView.width;
}

@end
