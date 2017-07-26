//
//  DialogTool.h
//  Pods
//
//  Created by xzh on 2017/6/25.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DialogTool : NSObject

+ (void)showDestructiveActionSheetWithTitle:(NSString *)title
                           destructiveTitle:(NSString *)destrucTitle
                                cancleTitle:(NSString *)cancelTitle handler:(void (^ __nullable)(UIAlertAction *action))handler;

+ (void)showDestructiveAlertWithTitle:(NSString *)title
                              message:(NSString *)message
                     destructiveTitle:(NSString *)destrucTitle
                          cancleTitle:(NSString *)cancelTitle handler:(void (^ __nullable)(UIAlertAction *action))handler;
@end

NS_ASSUME_NONNULL_END
