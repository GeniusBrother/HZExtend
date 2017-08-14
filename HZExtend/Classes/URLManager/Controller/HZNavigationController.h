//
//  HZNavigationController.h
//  ZHFramework
//
//  Created by xzh. on 15/8/25.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZNavigationController : UINavigationController

/** Specify YES to turn on global slide pop. Default is YES */
@property(nonatomic, assign) BOOL swipeEnable;

@property(nonatomic, assign) BOOL edgeRecognize;

@end

NS_ASSUME_NONNULL_END
