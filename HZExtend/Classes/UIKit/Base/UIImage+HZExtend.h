//
//  UIImage+HZTool.h
//  Pods
//
//  Created by xzh on 2016/12/6.
//
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HZResizeOption) {
    HZResizeOptionAspectFill = 0, //保持原宽高比填充
    HZResizeOptionAspectFit = 1,  //保持原宽高比完全显示
};

@interface UIImage (HZExtend)

/**
 *	获取视图截图
 *
 *	@param view  索要截图的视图
 *
 *  @return image
 */
+ (UIImage *)capatureImageInView:(UIView *)view;

/**
 *	调整图片尺寸
 *
 *	@param newSize  新的显示尺寸
 *
 *  @return image
 */
- (UIImage *)resizeImageToSize:(CGSize)newSize option:(HZResizeOption)option;

/**
 *	返回最适合当前屏幕的不会被缓存的image
 *  该图片不能存放在.xcassets目录里
 *
 *	@param name  图片文件名
 *
 *  @return UIImage实例,如果找不到该图片则返回nil
 */
+ (UIImage *)imageWithName:(NSString *)name;
@end
