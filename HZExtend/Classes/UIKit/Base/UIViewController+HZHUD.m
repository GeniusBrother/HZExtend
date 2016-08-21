//
//  HZViewController+HUD.m
//  ZHFramework
//
//  Created by xzh. on 15/8/24.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "UIViewController+HZHUD.h"
#import "NSObject+HZExtend.h"
#import <objc/runtime.h>
static const CGFloat kDelayPerCount = 5;
static const CGFloat kMinimumDelayTime = 1.5;
static const char HUD_DIC = '\0';

@implementation UIViewController (HZHUD)

+ (id<UIApplicationDelegate>)applicationDelegate
{
    return [UIApplication sharedApplication].delegate;
}

#pragma mark - 创建
#pragma mark
/**
 *  创建
 */
+ (MBProgressHUD *)hudWithText:(NSString *)text
                        detail:(NSString *)detail
                        toView:(UIView *)view
                       yOffset:(CGFloat)offset
{
    if (view == nil) view = [self applicationDelegate].window;

    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    hud.removeFromSuperViewOnHide = YES;
    hud.detailsLabelFont = hud.labelFont =[UIFont systemFontOfSize:15];
    hud.labelText = text;
    hud.detailsLabelText = detail;
    hud.yOffset = offset;
    [view addSubview:hud];
    
    return hud;
}

#pragma mark - 任务型
#pragma mark
#pragma mark Self
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

#pragma mark Window
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
- (void)successWithText:(NSString *)text image:(NSString *)successImage forKey:(NSString *)key
{
    MBProgressHUD *hud = [self.huds objectForKey:key];
    if (hud) {
        if (successImage.isNoEmpty) {
            [[self class] customHUD:hud image:successImage];
        }else {
            
        }
        hud.labelText = nil;
        hud.detailsLabelText = text;
        [[self class] delayHideHUD:hud withText:text];
    }
}

- (void)failWithText:(NSString *)text image:(NSString *)failImage forKey:(NSString *)key
{
    MBProgressHUD *hud = [self.huds objectForKey:key];
    if (hud) {
         [[self class] customHUD:hud image:failImage];
        hud.labelText = nil;
        hud.detailsLabelText = text;
        [[self class] delayHideHUD:hud withText:text];
    }
}

//Window
+ (void)successWithText:(NSString *)text image:(NSString *)successImage
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[self applicationDelegate].window];
    if (hud) {
         [[self class] customHUD:hud image:successImage];
        hud.labelText = nil;
        hud.detailsLabelText = text;
        [[self class] delayHideHUD:hud withText:text];
    }
}

+ (void)failWithText:(NSString *)text image:(NSString *)failImage
{
    MBProgressHUD *hud = [MBProgressHUD HUDForView:[self applicationDelegate].window];
    if (hud) {
         [[self class] customHUD:hud image:failImage];
        hud.labelText = nil;
        hud.detailsLabelText = text;
        [[self class] delayHideHUD:hud withText:text];
    }
}

#pragma mark - Private Method
+ (MBProgressHUD *)showFailWithText:(NSString *)text view:(UIView *)view image:(NSString *)failImage yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self  hudWithText:nil detail:text toView:view yOffset:offset];
    [self  customHUD:hud image:failImage];
    [self  showHUD:hud];
    [[self class] delayHideHUD:hud withText:text];
    return hud;
}

+ (MBProgressHUD *)showSuccessWithText:(NSString *)text view:(UIView *)view image:(NSString *)successImage yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self hudWithText:nil detail:text toView:view yOffset:offset];
    [self  customHUD:hud image:successImage];
    [self showHUD:hud];
    [[self class] delayHideHUD:hud withText:text];
    return hud;
}

+ (MBProgressHUD *)showMessage:(NSString *)message view:(UIView *)view yOffset:(CGFloat)offset
{
    MBProgressHUD *hud = [self hudWithText:nil detail:message toView:view yOffset:offset];
    hud.mode = MBProgressHUDModeText;
    hud.margin = 10.0f;
    hud.cornerRadius = 5.0f;
    [self showHUD:hud];
    [[self class] delayHideHUD:hud withText:message];
    return hud;
}

+ (void)customHUD:(MBProgressHUD *)hud image:(NSString *)customImage
{
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:customImage]];
}

#pragma mark - 一次性
#pragma mark
#pragma mark Success
- (MBProgressHUD *)showSuccessWithText:(NSString *)text image:(NSString *)successImage yOffset:(CGFloat)offset
{
    return [[self class] showSuccessWithText:text view:self.view image:successImage yOffset:offset];
}

+ (MBProgressHUD *)showWindowSuccessWithText:(NSString *)text image:(NSString *)successImage yOffset:(CGFloat)offset
{
    return [self showSuccessWithText:text view:nil image:successImage yOffset:offset];
}

- (MBProgressHUD *)showSuccessWithText:(NSString *)text image:(NSString *)successImage
{
    return [self showSuccessWithText:text image:successImage yOffset:0];
}

+ (MBProgressHUD *)showWindowSuccessWithText:(NSString *)text image:(NSString *)successImage;
{
    return [self showWindowSuccessWithText:text image:successImage yOffset:0];
}

#pragma mark Fail
- (MBProgressHUD *)showFailWithText:(NSString *)text image:(NSString *)failImage yOffset:(CGFloat)offset
{
    return [[self class] showFailWithText:text view:self.view image:failImage yOffset:offset];
}

- (MBProgressHUD *)showFailWithText:(NSString *)text image:(NSString *)failImage
{
    return [self showFailWithText:text image:failImage yOffset:0];
}

+ (MBProgressHUD *)showWindowFailWithText:(NSString *)text image:(NSString *)failImage yOffset:(CGFloat)offset
{
    return [self showFailWithText:text view:nil image:failImage yOffset:offset];
}

+ (MBProgressHUD *)showWindowFailWithText:(NSString *)text image:(NSString *)failImage
{
    return [self showWindowFailWithText:text image:failImage yOffset:0];
}

#pragma mark Message
- (MBProgressHUD *)showMessage:(NSString *)message yOffset:(CGFloat)offset
{
    return [[self class] showMessage:message view:self.view yOffset:offset];
}

- (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message yOffset:0];
}

+ (MBProgressHUD *)showWindowMessage:(NSString *)message yOffset:(CGFloat)offset
{
    return [self showMessage:message view:nil yOffset:offset];
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

- (void)hideHudForKey:(NSString *)key
{
    MBProgressHUD *hud = [self.huds objectForKey:key];
    if (hud) {
        [[self class] hideHUD:hud];
    }
}

- (void)showHudForKey:(NSString *)key
{
    MBProgressHUD *hud = [self.huds objectForKey:key];
    if (hud) {
        [[self class] showHUD:hud];
    }
}

/**
 *  根据文字的长度来延迟隐藏
 */
+ (void)delayHideHUD:(MBProgressHUD *)hud withText:(NSString *)text
{
    NSTimeInterval time = (text.length / kDelayPerCount) >=kMinimumDelayTime?(text.length / kDelayPerCount):kMinimumDelayTime;
    [hud hide:YES afterDelay:time];
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
