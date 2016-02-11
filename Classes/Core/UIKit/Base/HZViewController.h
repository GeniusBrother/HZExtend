//
//  HZViewController.h
//  HZNetworkDemo
//
//  Created by xzh on 16/1/22.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HZViewModel.h"
@class SessionTask;
@interface HZViewController : UIViewController<HZViewModelDelegate>

#pragma mark - Override
#pragma mark Request Call-back
/**
 *  页面数据的设置,不涉及状态
 */
- (void)setupSuccessDataWithTask:(SessionTask *)task type:(NSString *)type;

/**
 *  失败处理,不涉及状态
 */
- (void)requestFailWithTask:(SessionTask *)task type:(NSString *)type;

@end
