//
//  HZViewController+HUD.m
//  ZHFramework
//
//  Created by xzh. on 15/8/24.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "UIViewController+HZHUD.h"
#import <objc/runtime.h>
static const CGFloat DELAY_TIME = 1;
static NSString *const hudFailImage = @"error";
static NSString *const HUD_SuccessImage = @"success";
static const char HUD_DIC = '\0';

@implementation UIViewController (HZHUD)

#pragma mark - 创建
/**
 *  创建基本的HUD(隐藏后remove)
 */
+ (MBProgressHUD *)hudWithText:(NSString *)text
                        detail:(NSString *)detail
                        toView:(UIView *)view
                       yOffset:(CGFloat)offset
{
    if (view == nil) view = [UIApplication sharedApplication].keyWindow;

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.labelText = text;
    hud.detailsLabelText = detail;
    hud.yOffset = offset;
    [view addSubview:hud];
    
    return hud;
}

#pragma mark - 任务型
#pragma mark SELF
//progress
- (MBProgressHUD *)showIndicatorWithText:(NSString *)text yOffset:(CGFloat)offset forKey:(NSString *)key
{
    MBProgressHUD *hud = [[self class]  hudWithText:text detail:nil toView:self.view yOffset:offset];
    [[self class]  showHUD:hud];
    [self.huds setObject:hud forKey:key];
    
    return hud;
}

- (MBProgressHUD *)showBarWithText:(NSString *)text yOffset:(CGFloat)offset forKey:(NSString *)key
{
    MBProgressHUD *hud = [[self class]  hudWithText:text detail:nil toView:self.view yOffset:offset];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    [[self class]  showHUD:hud];
    [self.huds setObject:hud forKey:key];
    
    return hud;
}

- (MBProgressHUD *)showIndicatorWithText:(NSString *)text forKey:(NSString *)key
{
    return [self showIndicatorWithText:text yOffset:0 forKey:key];
}

- (MBProgressHUD *)showBarWithText:(NSString *)text forKey:(NSString *)key
{
    return [self showBarWithText:text yOffset:0 forKey:key];
}

#pragma mark WINDOW
+ (MBProgressHUD *)showWindowIndicatorWithText:(NSString *)text yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self hudWithText:text detail:nil toView:nil yOffset:offset];
    [self showHUD:hud];
    return hud;
}

+ (MBProgressHUD *)showWindowBarWithText:(NSString *)text yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self hudWithText:text detail:nil toView:nil yOffset:offset];
    hud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    [self showHUD:hud];
    return hud;
}

+ (MBProgressHUD *)showWindowIndicatorWithText:(NSString *)text
{
    return [self showWindowIndicatorWithText:text yOffset:0];
}

+ (MBProgressHUD *)showWindowBarWithText:(NSString *)text
{
    return [self showWindowBarWithText:text yOffset:0];
}

#pragma mark Complete
//self
- (void)successWithText:(NSString *)text forKey:(NSString *)key
{
    MBProgressHUD *hud = [self.huds objectForKey:key];
    if (hud) {
        [[self class]  successHUD:hud];
        hud.labelText = text;
        [hud hide:YES afterDelay:DELAY_TIME];
    }
}

- (void)failWithText:(NSString *)text forKey:(NSString *)key
{
    MBProgressHUD *hud = [self.huds objectForKey:key];
    if (hud) {
        [[self class]  failHUD:hud];
        hud.labelText = text;
        [hud hide:YES afterDelay:DELAY_TIME];
    }
}

//window
+ (void)successWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud) {
        [self successHUD:hud];
        hud.labelText = text;
        [hud hide:YES afterDelay:DELAY_TIME];
    }
}

+ (void)failWithText:(NSString *)text
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[UIApplication sharedApplication].keyWindow];
    if (hud) {
        [self failHUD:hud];
        hud.labelText = text;
        [hud hide:YES afterDelay:DELAY_TIME];
    }
}

#pragma mark - 提示性
#pragma mark Private Method
+ (MBProgressHUD *)showFailWithText:(NSString *)text view:(UIView *)view yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self  hudWithText:text detail:nil toView:view yOffset:offset];
    [self  failHUD:hud];
    [self  showHUD:hud];
    [hud hide:YES afterDelay:DELAY_TIME];
    return hud;
}

+ (MBProgressHUD *)showSuccessWithText:(NSString *)text view:(UIView *)view yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self hudWithText:text detail:nil toView:view yOffset:offset];
    [self successHUD:hud];
    [self showHUD:hud];
    [hud hide:YES afterDelay:DELAY_TIME];
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message view:(UIView *)view yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self hudWithText:message detail:nil toView:view yOffset:offset];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.0f;
    hud.cornerRadius = 5.0f;
    [self showHUD:hud];
    [hud hide:YES afterDelay:DELAY_TIME];
    
    return hud;
}

#pragma mark Public Method
#pragma mark Public SUCCESS
- (MBProgressHUD *)showSuccessWithText:(NSString *)text yOffset:(CGFloat)offset
{
    return [[self class]showSuccessWithText:text view:self.view yOffset:offset];
}

+ (MBProgressHUD *)showWindowSuccessWithText:(NSString *)text yOffset:(CGFloat)offset
{
    return [self showSuccessWithText:text view:nil yOffset:offset];
}

- (MBProgressHUD *)showSuccessWithText:(NSString *)text;
{
    return [self showSuccessWithText:text yOffset:0];
}

+ (MBProgressHUD *)showWindowSuccessWithText:(NSString *)text;
{
    return [self showWindowSuccessWithText:text yOffset:0];
}

#pragma mark Public FAIL
- (MBProgressHUD *)showFailWithText:(NSString *)text yOffset:(CGFloat)offset
{
    return [[self class] showFailWithText:text view:self.view yOffset:offset];
}

+ (MBProgressHUD *)showWindowFailWithText:(NSString *)text yOffset:(CGFloat)offset
{
    return [self showFailWithText:text view:nil yOffset:offset];
}

- (MBProgressHUD *)showFailWithText:(NSString *)text
{
    return [self showFailWithText:text yOffset:0];
}

+ (MBProgressHUD *)showWindowFailWithText:(NSString *)text
{
    return [self showWindowFailWithText:text yOffset:0];
}

#pragma mark Public MESSAGE
- (MBProgressHUD *)showMessage:(NSString *)message yOffset:(CGFloat)offset
{
    return [[self class] showMessage:message view:self.view yOffset:offset];
}

+ (MBProgressHUD *)showWindowMessage:(NSString *)message yOffset:(CGFloat)offset
{
    return [self showMessage:message view:nil yOffset:offset];
}

- (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message yOffset:0];
}

+ (MBProgressHUD *)showWindowMessage:(NSString *)message
{
    return [self showWindowMessage:message yOffset:0];
}

#pragma mark - Hide & Show
+ (void)hideHUD:(MBProgressHUD *)hud
{
    [hud hide:YES];
}

+ (void)showHUD:(MBProgressHUD *)hud
{
    if (hud.superview) {
        [hud.superview bringSubviewToFront:hud];
    }
    
    [hud show:YES];
}

#pragma mark - Success & Fail
+ (void)failHUD:(MBProgressHUD *)hud
{
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
}

+ (void)successHUD:(MBProgressHUD *)hud
{
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"success"]];
}

#pragma mark - Property
- (NSMutableDictionary *)huds
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &HUD_DIC);
    if (!dic) {
        dic = [NSMutableDictionary dictionary];
        [self setHuds:dic];
    }
    return dic;
}

- (void)setHuds:(NSMutableDictionary *)huds
{
    NSMutableDictionary *dic = objc_getAssociatedObject(self, &HUD_DIC);
    if (dic != huds) {
        [self willChangeValueForKey:@"huds"];
        objc_setAssociatedObject(self, &HUD_DIC, huds, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"huds"];
    }
}

@end
