//
//  UIResponder+HZAction.h
//  Pods
//
//  Created by xzh on 2017/2/26.
//
//

#import <UIKit/UIKit.h>

@interface UIResponder (HZAction)

//遍历响应者链上能响应指定消息的响应者
- (void)enumerateMethodResponserWithSelector:(SEL)selector usingBlock:(void (^)(UIResponder *responder))block;

@end
