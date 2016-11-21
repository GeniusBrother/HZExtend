//
//  UIViewController+HZExtend.h
//  mcapp
//
//  Created by xzh on 2016/11/20.
//  Copyright © 2016年 发条橙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (HZExtend)

- (void)performTask:(void(^)(BOOL done))block;

@end
