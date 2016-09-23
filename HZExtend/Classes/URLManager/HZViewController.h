//
//  HZViewController.h
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+HZHUD.h"
#import "HZNavigationController.h"
#import "HZViewModel.h"
@class HZSessionTask;
@interface HZViewController : UIViewController<HZViewModelDelegate>
/**
 *  若导航控制器类型为HZNavigationController则返回,否则返回nil
 */
@property(nonatomic, strong, readonly) HZNavigationController *nav;

/**
 *  页面数据的设置,不涉及状态
 */
- (void)setupSuccessDataWithTask:(HZSessionTask *)task type:(NSString *)type;

/**
 *  失败处理,不涉及状态
 */
- (void)requestFailWithTask:(HZSessionTask *)task type:(NSString *)type;

@end
