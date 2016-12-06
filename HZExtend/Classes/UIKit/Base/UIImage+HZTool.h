//
//  UIImage+HZTool.h
//  Pods
//
//  Created by xzh on 2016/12/6.
//
//

#import <UIKit/UIKit.h>

@interface UIImage (HZTool)

/**
 *	获取视图截图
 *
 *	@param view  索要截图的视图
 *
 *  @return image
 */
+ (UIImage *)capatureImageInView:(UIView *)view;

@end
