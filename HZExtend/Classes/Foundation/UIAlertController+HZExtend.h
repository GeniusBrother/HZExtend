//
//  UIAlertController+HZExtend.h
//  Pods
//
//  Created by xzh on 2017/8/11.
//
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UIAlertController (HZExtend)

+ (void)showDestructiveActionSheetWithTitle:(NSString *)title
                           destructiveTitle:(NSString *)destrucTitle
                                cancleTitle:(NSString *)cancelTitle handler:(void (^ __nullable)(UIAlertAction *action))handler;

+ (void)showDestructiveAlertWithTitle:(NSString *)title
                              message:(NSString *)message
                     destructiveTitle:(NSString *)destrucTitle
                          cancleTitle:(NSString *)cancelTitle handler:(void (^ __nullable)(UIAlertAction *action))handler;

@end

NS_ASSUME_NONNULL_END
