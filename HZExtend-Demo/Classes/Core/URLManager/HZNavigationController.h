//
//  HZNavigationController.h
//  ZHFramework
//
//  Created by xzh. on 15/8/25.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZNavigationController : UINavigationController
/**
 *  是否开启侧滑
 */
@property(nonatomic, assign) BOOL swipeEnable;

/**
 *  当子控制器的数量<=改值时不触发侧滑手势,默认为1
 */
@property(nonatomic, assign) NSUInteger countOfNoPanChild;

@end
