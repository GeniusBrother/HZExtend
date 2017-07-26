//
//  DialogTool.m
//  Pods
//
//  Created by xzh on 2017/6/25.
//
//

#import "DialogTool.h"
#import "HZURLManager.h"
@implementation DialogTool

#pragma mark - Public Method
+ (void)showDestructiveActionSheetWithTitle:(NSString *)title
                           destructiveTitle:(NSString *)destrucTitle
                                cancleTitle:(NSString *)cancelTitle
                                    handler:(void (^)(UIAlertAction *))handler
{
    [self showAlertWithStyle:UIAlertControllerStyleActionSheet title:title message:@"" destructiveTitle:destrucTitle cancleTitle:cancelTitle handler:handler];
}

+ (void)showDestructiveAlertWithTitle:(NSString *)title
                              message:(NSString *)message
                     destructiveTitle:(NSString *)destrucTitle
                          cancleTitle:(NSString *)cancelTitle
                              handler:(void (^)(UIAlertAction * _Nonnull))handler
{
    [self showAlertWithStyle:UIAlertControllerStyleAlert title:title message:message destructiveTitle:destrucTitle cancleTitle:cancelTitle handler:handler];
}

#pragma mark - Private Method
+ (void)showAlertWithStyle:(UIAlertControllerStyle)style
                     title:(NSString *)title
                   message:(NSString *)message
          destructiveTitle:(NSString *)destrucTitle
               cancleTitle:(NSString *)cancelTitle
                   handler:(void (^)(UIAlertAction *))handler
{
    UIAlertController *alerController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:style];
    UIAlertAction *destrucAction = [UIAlertAction actionWithTitle:destrucTitle style:UIAlertActionStyleDestructive handler:handler];
    [alerController addAction:destrucAction];
    
    UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancelTitle style:UIAlertActionStyleCancel handler:handler];
    [alerController addAction:cancleAction];
    [HZURLManager presentViewController:alerController animated:YES completion:nil];
}

@end
