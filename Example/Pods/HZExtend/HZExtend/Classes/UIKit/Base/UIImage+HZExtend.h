//
//  UIImage+HZExtend.h
//  Pods
//
//  Created by xzh on 16/9/13.
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (HZExtend)

- (nullable UIImage *)compressImageToScale:(CGFloat)scale;

- (nullable UIImage *)compressImageToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END