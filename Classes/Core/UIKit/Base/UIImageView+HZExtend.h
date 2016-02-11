//
//  UIImageView+HZExtend.h
//  mcapp
//
//  Created by xzh on 16/1/8.
//  Copyright © 2016年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
@interface UIImageView (HZExtend)

/*@Description:
 1.无url则直接设置为image
 2.老图片:若本地已经有图片，则直接从本地加载.
 3.新图片:设置占位，从远处加载
 */
- (void)safeSetImageWithURL:(NSString *)url placeholder:(UIImage *)image;

@end
