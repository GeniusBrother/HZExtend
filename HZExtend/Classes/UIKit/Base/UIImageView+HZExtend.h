//
//  UIImageView+HZExtend.h
//  mcapp
//
//  Created by xzh on 16/1/8.
//  Copyright © 2016年 zhuchao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface UIImageView (HZExtend)


/**
 *	下载并缓存图片，然后设置给imageView
 *  @discussion  无url则直接设置为image,若本地已经有URL对应的图片，则直接从本地加载 否则设置先设置占位，从远处加载
 *
 *	@param url  图片地址
 *  @param image  占位图
 */
/*

 */
- (void)safeSetImageWithURL:(NSString *)url placeholder:(UIImage *)image;

@end
