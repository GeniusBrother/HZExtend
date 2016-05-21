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
 *  text:标题，detail:解释信息，view:nil则添加到window上，offset:竖直方向距离中心的偏移
 */
+ (MBProgressHUD *)hudWithText:(NSString *)text
                        detail:(NSString *)detail
                        toView:(UIView *)view
                       yOffset:(CGFloat)offset;

/**
 *  self.view上的全部hud,一个key对应一个hud，所以可通过key来获取对应的hud
 */
- (NSMutableDictionary<NSString *, MBProgressHUD *> *)huds;

/********等待型********/
/**
 *	在self.view上 show等待样式的Hud
 *
 *	@param key 标识hud的key
 */
- (MBProgressHUD *)showIndicatorWithText:(NSString *)text forKey:(NSString *)key;   //key用来获取对应的hud
- (MBProgressHUD *)showIndicatorWithText:(NSString *)text yOffset:(CGFloat)offset forKey:(NSString *)key;
- (MBProgressHUD *)showBarWithText:(NSString *)text forKey:(NSString *)key;
- (MBProgressHUD *)showBarWithText:(NSString *)text yOffset:(CGFloat)offset forKey:(NSString *)key;

/**
 * 在base window上show等待样式的Hud
 */
+ (MBProgressHUD *)showWindowIndicatorWithText:(NSString *)text;
+ (MBProgressHUD *)showWindowBarWithText:(NSString *)text;
+ (MBProgressHUD *)showWindowIndicatorWithText:(NSString *)text yOffset:(CGFloat)offset;
+ (MBProgressHUD *)showWindowBarWithText:(NSString *)text yOffset:(CGFloat)offset;

/********结束等待型********/
/**
 *	在self.view上 show等待样式的Hud后，可以调用这个接口将hud切换为成功或者失败的状态
 *
 *	@param key 标识hud的key
 */
- (void)successWithText:(NSString *)text image:(NSString *)successImage forKey:(NSString *)key;
- (void)failWithText:(NSString *)text image:(NSString *)failImage forKey:(NSString *)key;

/**
 *  在base window上show等待样式的Hud后，可以调用这个接口将hud切换为成功或者失败的状态
 */
+ (void)successWithText:(NSString *)text image:(NSString *)successImage;
+ (void)failWithText:(NSString *)text image:(NSString *)failImage;


/********一次性类型********/
/**
 *	展示在self.view上 如果不需要经历等待状态，可以直接调用以下接口展示成功或者失败
 *
 *	@param yOffset  竖直方向的距离中心的偏移
 */
- (MBProgressHUD *)showSuccessWithText:(NSString *)text image:(NSString *)successImage;
- (MBProgressHUD *)showSuccessWithText:(NSString *)text image:(NSString *)successImage yOffset:(CGFloat)offset;
- (MBProgressHUD *)showFailWithText:(NSString *)text image:(NSString *) failImage;
- (MBProgressHUD *)showFailWithText:(NSString *)text image:(NSString *)failImage yOffset:(CGFloat)offset;

- (MBProgressHUD *)showMessage:(NSString *)message;
- (MBProgressHUD *)showMessage:(NSString *)message yOffset:(CGFloat)offset;

/**
 *  展示在base window上 如果不需要经历等待状态，可以直接调用以下接口展示成功或者失败
 */
+ (MBProgressHUD *)showWindowSuccessWithText:(NSString *)text image:(NSString *)successImage;
+ (MBProgressHUD *)showWindowSuccessWithText:(NSString *)text image:(NSString *)successImage yOffset:(CGFloat)offset;
+ (MBProgressHUD *)showWindowFailWithText:(NSString *)text image:(NSString *)failImage;
+ (MBProgressHUD *)showWindowFailWithText:(NSString *)text image:(NSString *)failImage yOffset:(CGFloat)offset;
+ (MBProgressHUD *)showWindowMessage:(NSString *)message;
+ (MBProgressHUD *)showWindowMessage:(NSString *)message yOffset:(CGFloat)offset;


/****************************Show & Hide****************************/

+ (void)hideHUD:(MBProgressHUD *)hud;
+ (void)showHUD:(MBProgressHUD *)hud;

/**
 *	根据key来show或者hide hud
 *
 *	@param key hud的标识
 */
- (void)hideHudForKey:(NSString *)key;
- (void)showHudForKey:(NSString *)key;

@end
