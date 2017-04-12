//
//  HZNavigationController.h
//  ZHFramework
//
//  Created by xzh. on 15/8/25.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HZNavigationController : UINavigationController

/** 是否开启侧滑,默认为YES */
@property(nonatomic, assign) BOOL swipeEnable;

@property(nonatomic, assign) BOOL edgeRecognize;

@end
