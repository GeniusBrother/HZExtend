//
//  HZFit.m
//  Pods
//
//  Created by xzh on 16/10/2.
//
//

#import "HZFit.h"
#import "HZMacro.h"
@implementation HZFit

static CGFloat referenceScreenWidth;
static CGFloat referenceScreenHeight;

+ (void)configReferenceScreenSize:(CGSize)size
{
    referenceScreenWidth = size.width;
    referenceScreenHeight = size.height;
}

+ (CGFloat)xFitDataForReferenceValue:(CGFloat)xReferenceValue
{
    NSAssert(referenceScreenWidth != 0 && referenceScreenHeight != 0, @"请调用configReferenceScreenSize来指定参照的屏幕尺寸");
    return xReferenceValue * (HZDeviceWidth / referenceScreenWidth);
}

+ (CGFloat)yFitDataForReferenceValue:(CGFloat)yReferenceValue
{
    NSAssert(referenceScreenWidth != 0 && referenceScreenHeight != 0, @"请调用configReferenceScreenSize来指定参照的屏幕尺寸");
    return yReferenceValue * (HZDeviceHeight / referenceScreenHeight);
}

@end
