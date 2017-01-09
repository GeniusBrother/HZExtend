//
//  HZNavBar.m
//  mcapp
//
//  Created by xzh on 2016/12/13.
//  Copyright © 2016年 发条橙. All rights reserved.
//

#import "HZNavBar.h"

@interface HZNavBar ()

@property(nonatomic, weak) UILabel *titleLabel;

@property(nonatomic, weak) UIView *leftContainerView;
@property(nonatomic, weak) UIView *rightContainerView;
@property(nonatomic, weak) UIView *centerContainerView;

@property(nonatomic, weak) UIView *leftCustomView;
@property(nonatomic, weak) UIView *centerCustomView;
@property(nonatomic, weak) UIView *rightCustomView;
@property(nonatomic, strong) NSNumber *rightOffset;

@end

@implementation HZNavBar
#pragma mark - Initialization
+ (instancetype)navBarWithTitle:(NSString *)title
{
    return [self navBarWithTitle:title leftButton:nil];
}

+ (instancetype)navBarWithLeftButton:(NSString *)buttonName
{
    return [self navBarWithTitle:nil leftButton:buttonName];
}

+ (instancetype)navBarWithTitle:(NSString *)title leftButton:(NSString *)buttonName
{
    HZNavBar *navBar = [[self alloc] initWithFrame:CGRectMake(0, 0, HZDeviceWidth, HZNavBarHeight)];
    if (title.isNoEmpty) navBar.titleLabel.text = title;
    [navBar addLeftButtonWithName:buttonName offset:nil];
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
    self.backgroundColor = [UIColor whiteColor];
}

#pragma mark - UI
- (void)loadSubViews
{
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.leftContainerView) {
        self.leftCustomView.top = (self.leftContainerView.height - self.leftCustomView.height)/2;
        self.leftContainerView.width = self.leftCustomView.right;
    }
    
    if (self.rightContainerView) {
        self.rightCustomView.top = (self.rightContainerView.height - self.rightCustomView.height)/2;
        CGFloat offsetDistance = self.rightOffset.isNoEmpty?self.rightOffset.doubleValue:kNavBarDefaultSpace;
        self.rightContainerView.width = self.rightCustomView.right + offsetDistance;
        self.rightContainerView.left = self.width - self.rightContainerView.width;
    }
    
    if (self.centerContainerView) {
        if (self.centerCustomView == _titleLabel) {
            CGFloat halfWith = self.width / 2;
            
            CGFloat sideDistance = MIN(halfWith - self.leftContainerView.width, halfWith - self.rightContainerView.width) - 10; //距离2边至少10空隙
            [self.titleLabel sizeToFit];
            self.titleLabel.width = sideDistance * 2;
        }
        
        self.centerCustomView.top = (self.centerContainerView.height - self.centerCustomView.height)/2;
        self.centerContainerView.width = self.centerCustomView.right;
        self.centerContainerView.left = (self.width - self.centerContainerView.width)/2;
    }
    
}


#pragma mark - Public Method
#pragma mark Left View
- (void)addLeftCustomView:(UIView *)customView
{
    if (!customView) return;
    
    [self.leftCustomView removeFromSuperview];
    
    self.leftCustomView = customView;
    [self.lazy_leftContainerView addSubview:customView];
}

- (void)addLeftButtonWithName:(NSString *)buttonName offset:(nullable NSNumber *)offset
{
    if (!buttonName.isNoEmpty) return;
    
    CGFloat offsetDistance = offset.isNoEmpty?offset.doubleValue:kNavBarDefaultSpace;
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(offsetDistance, 0, 44, 44);
    [leftButton setImage:[UIImage imageNamed:buttonName] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
//    ADD_BACKGROUND_COLOR(leftButton, [UIColor purpleColor]);
    [self addLeftCustomView:leftButton];
}

#pragma mark Center View
- (void)addCenterCustomView:(UIView *)customView
{
    if (!customView) return;
    [self.centerCustomView removeFromSuperview];
    
    self.centerCustomView = customView;
    [self.lazy_centerContainerView addSubview:customView];
}

#pragma mark Right View
- (void)addRightCustomView:(UIView *)customView offset:(nullable NSNumber *)offset
{
    if (!customView) return;
    [self.rightCustomView removeFromSuperview];
    
    self.rightOffset = offset;
    self.rightCustomView = customView;
    [self.lazy_rightContainerView addSubview:customView];
    
}

#pragma mark - Lazy Load
- (UIView *)lazy_leftContainerView
{
    if (!_leftContainerView) {
        UIView *leftContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 0, 44)];
//        ADD_BACKGROUND_COLOR(leftContainerView,[UIColor redColor]);
        [self addSubview:leftContainerView];
        _leftContainerView = leftContainerView;
    }
    return _leftContainerView;
}

- (UIView *)lazy_rightContainerView
{
    if (!_rightContainerView) {
        UIView *rightContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 0, 44)];
//        ADD_BACKGROUND_COLOR(rightContainerView,[UIColor brownColor]);
        [self addSubview:rightContainerView];
        _rightContainerView = rightContainerView;
    }
    return _rightContainerView;
}

- (UIView *)lazy_centerContainerView
{
    if (!_centerContainerView) {
        UIView *centerContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 0, 44)];
//        ADD_BACKGROUND_COLOR(centerContainerView,[UIColor brownColor]);
        [self addSubview:centerContainerView];
        _centerContainerView = centerContainerView;
    }
    return _centerContainerView;

}

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
    }
    return _titleLabel;
}

#pragma mark - Action
- (void)leftButtonClick:(UIButton *)sender
{
    [HZURLManager dismissCurrentAnimated:YES];
}

@end
