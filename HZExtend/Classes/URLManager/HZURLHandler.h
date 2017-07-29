//
//  HZURLHandler.h
//  Pods
//
//  Created by xzh on 2017/7/28.
//
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HZURLHandler <NSObject>

- (id)handleURL:(NSString *)url withTarget:(id)target withParams:(nullable id)params;

@end

NS_ASSUME_NONNULL_END
