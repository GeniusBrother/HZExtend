//
//  HZFit.h
//  Pods
//
//  Created by xzh on 16/10/2.
//  HZFit代表一个布局适配器,按照比例对所有数据进行放大或缩小,x轴方向的数据=referenceValue * nowScreenWidth / referenceScreenWidth,y轴方向的数据=referenceValue * nowScreenHeight / referenceScreenHeight
//

#import <Foundation/Foundation.h>

@interface HZFit : NSObject

/**
 *	指定参照的屏幕size
 *
 *	@param size  参照的屏幕size
 */
+ (void)configReferenceScreenSize:(CGSize)size;

/**
 *	获取值在x轴上适配后的数据
 *
 *	@param refernceValue  x轴上的参照数据
 *
 *  @return 一个CGFolat类型的适配后的数据
 */
+ (CGFloat)xFitDataForReferenceValue:(CGFloat)xReferenceValue;

/**
 *	获取值在Y轴上适配后的数据
 *
 *	@param refernceValue  y轴上的参照数据
 *
 *  @return 一个CGFolat类型的适配后的数据
 */
+ (CGFloat)yFitDataForReferenceValue:(CGFloat)yReferenceValue;


@end
