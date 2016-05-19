//
//  HZViewController+HUD.h
//  ZHFramework
//
//  Created by xzh. on 15/8/24.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@interface UIViewController (HZHUD)

/**
 *  创建HUD
 *  text:标题，detail:解释信息，view:nil则添加到window上，offset:竖直方向的中心距离偏移
 */
+ (MBProgressHUD *)hudWithText:(NSString *)text
                        detail:(NSString *)detail
                        toView:(UIView *)view
                       yOffset:(CGFloat)offset;

/**
 *  视图控制器的全部hud,用展示时的key获取
 */
- (NSMutableDictionary *)huds;

/********过程型********/
- (MBProgressHUD *)showIndicatorWithText:(NSString *)text forKey:(NSString *)key;   //key用来获取对应的hud
- (MBProgressHUD *)showBarWithText:(NSString *)text forKey:(NSString *)key;

- (MBProgressHUD *)showIndicatorWithText:(NSString *)text yOffset:(CGFloat)offset forKey:(NSString *)key;
- (MBProgressHUD *)showBarWithText:(NSString *)text yOffset:(CGFloat)offset forKey:(NSString *)key;

/********结束过程型********/
- (void)successWithText:(NSString *)text forKey:(NSString *)key;
- (void)failWithText:(NSString *)text forKey:(NSString *)key;

/********一次性********/
- (MBProgressHUD *)showSuccessWithText:(NSString *)text;
- (MBProgressHUD *)showFailWithText:(NSString *)text;
- (MBProgressHUD *)showMessage:(NSString *)message;

- (MBProgressHUD *)showFailWithText:(NSString *)text yOffset:(CGFloat)offset;
- (MBProgressHUD *)showSuccessWithText:(NSString *)text yOffset:(CGFloat)offset;
- (MBProgressHUD *)showMessage:(NSString *)message yOffset:(CGFloat)offset;

/********keyWindow类型********/
+ (MBProgressHUD *)showWindowIndicatorWithText:(NSString *)text;
+ (MBProgressHUD *)showWindowBarWithText:(NSString *)text;

+ (MBProgressHUD *)showWindowIndicatorWithText:(NSString *)text yOffset:(CGFloat)offset;
+ (MBProgressHUD *)showWindowBarWithText:(NSString *)text yOffset:(CGFloat)offset;

+ (void)successWithText:(NSString *)text;
+ (void)failWithText:(NSString *)text;

+ (MBProgressHUD *)showWindowSuccessWithText:(NSString *)text;
+ (MBProgressHUD *)showWindowFailWithText:(NSString *)text;
+ (MBProgressHUD *)showWindowMessage:(NSString *)message;

+ (MBProgressHUD *)showWindowSuccessWithText:(NSString *)text yOffset:(CGFloat)offset;
+ (MBProgressHUD *)showWindowFailWithText:(NSString *)text yOffset:(CGFloat)offset;
+ (MBProgressHUD *)showWindowMessage:(NSString *)message yOffset:(CGFloat)offset;


+ (void)hideHUD:(MBProgressHUD *)hud;
+ (void)showHUD:(MBProgressHUD *)hud;

@end
