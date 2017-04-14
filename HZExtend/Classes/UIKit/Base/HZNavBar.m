//
//  HZNavBar.m
//  mcapp
//
//  Created by xzh on 2016/12/13.
//  Copyright © 2016年 发条橙. All rights reserved.
//

#import "HZNavBar.h"
#import "HZMacro.h"
#import "UIView+HZExtend.h"
#import "NSObject+HZExtend.h"
#import "HZURLManager.h"
#import <Masonry/Masonry.h>
#import "HZNavLeftContainerView.h"
#import "HZNavRightContainerView.h"
@interface HZNavBar ()

@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UIView *leftCustomView;
@property(nonatomic, weak) UIView *centerCustomView;
@property(nonatomic, weak) UIView *rightCustomView;


@end

@implementation HZNavBar
#pragma mark - Initialization
+ (instancetype)navBarWithTitle:(NSString *)title
{
    HZNavBar *navBar = [[self alloc] initWithFrame:CGRectMake(0, 0, HZDeviceWidth, HZNavBarHeight)];
    if (title.isNoEmpty) navBar.titleLabel.text = title;
    return navBar;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        [self loadSubViews];
    }
    return self;
}

#pragma mark - Private Method
- (void)setup
{
    
}


#pragma mark - UI
- (void)loadSubViews
{
    self.backgroundColor = [UIColor whiteColor];
}



#pragma mark - Public Method
- (void)addLeftCustomView:(UIView *)customView
{
    if (!customView) return;
    
    [self.leftCustomView removeFromSuperview];
    
    [self addSubview:customView];
    self.leftCustomView = customView;
}

- (void)addCenterCustomView:(UIView *)customView
{
    if (!customView) return;
    
    [self.centerCustomView removeFromSuperview];
    
    [self addSubview:customView];
    self.centerCustomView = customView;
}

- (void)addRightCustomView:(UIView *)customView
{
    if (!customView) return;
    
    [self.rightCustomView removeFromSuperview];

    [self addSubview:customView];
    self.rightCustomView = customView;
}

#pragma mark - Lazy Load
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        titleLabel.font = [UIFont systemFontOfSize:17.0f];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.numberOfLines = 1;
        [self addCenterCustomView:titleLabel];
        _titleLabel = titleLabel;
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(@0);
            make.top.equalTo(@20);
            make.height.equalTo(@44);
        }];
    }
    return _titleLabel;
}
@end
