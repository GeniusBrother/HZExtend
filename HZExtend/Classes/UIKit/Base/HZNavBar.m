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
#import "HZNavLeftContainerView.h"
#import "HZNavRightContainerView.h"
#import "UIView+HZAction.h"
@interface HZNavBar ()

@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UIView *leftCustomView;
@property(nonatomic, weak) UIView *centerCustomView;
@property(nonatomic, weak) UIView *rightCustomView;

@property(nonatomic, copy) HZNavBarActionBlock leftCallback;
@property(nonatomic, copy) HZNavBarActionBlock rightCallback;


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
- (void)addRightCustomView:(UIView *)rightCustomView callback:(nullable HZNavBarActionBlock)callBack
{
    if (!rightCustomView) return;
    [self.rightCustomView removeFromSuperview];
    
    [self addSubview:rightCustomView];
    self.rightCustomView = rightCustomView;
    
    
    if (callBack) {
        if ([rightCustomView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)rightCustomView;
            [btn addTarget:self action:@selector(rightClick:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [rightCustomView tapPeformBlock:^(UIView *view) {
                callBack(view);
            }];
        }
    }
    self.rightCallback = callBack;
}

- (void)addLeftCustomView:(UIView *)leftCustomView callback:(nullable HZNavBarActionBlock)callBack
{
    if (!leftCustomView) return;
    
    [self.leftCustomView removeFromSuperview];
    
    [self addSubview:leftCustomView];
    self.leftCustomView = leftCustomView;
    
    if (callBack) {
        if ([leftCustomView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)leftCustomView;
            [btn addTarget:self action:@selector(leftClick:) forControlEvents:UIControlEventTouchUpInside];
        }else {
            [leftCustomView tapPeformBlock:^(UIView *view) {
                callBack(view);
            }];
        }
    }
    
    self.leftCallback = callBack;
}

- (void)addLeftCustomView:(UIView *)customView
{
    [self addLeftCustomView:customView callback:nil];
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
    [self addRightCustomView:customView callback:nil];
}

#pragma mark - Action
- (void)leftClick:(UIButton *)btn
{
    if (self.leftCallback) {
        self.leftCallback(btn);
    }
}

- (void)rightClick:(UIButton *)btn
{
    if (self.rightCallback) {
        self.rightCallback(btn);
    }
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
        titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addConstraints:@[[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0],[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1.0 constant:20]]];
        [titleLabel addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44]];
    }
    return _titleLabel;
}
@end
