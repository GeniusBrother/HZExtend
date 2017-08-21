//
//  HZORMUtils.m
//  Pods
//
//  Created by xzh on 2017/8/21.
//
//

#import "HZORMUtils.h"
#import <objc/runtime.h>

@implementation HZORMUtils

+ (NSArray<NSString *> *)allPropertyNamesWithClass:(Class)cla
{
    unsigned int outCount, i;
    objc_property_t * properties = class_copyPropertyList(cla, &outCount);
    NSMutableArray *names = [NSMutableArray arrayWithCapacity:outCount];
    
    for (i = 0; i < outCount; i++) {
        objc_property_t property =properties[i];
        //  属性名转成字符串
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        // 判断该属性是否存在
        if (propertyName) [names addObject:propertyName];
    }
    free(properties);
    
    return names;
}


@end
