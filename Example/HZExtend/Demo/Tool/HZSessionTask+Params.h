//
//  HZSessionTask+Params.h
//  HZExtend
//
//  Created by xzh on 2016/10/18.
//  Copyright © 2016年 GeniusBrother. All rights reserved.
//

#import <HZExtend/HZSessionTask.h>

@interface HZSessionTask (Params)

/** 为请求任务设置page参数 */
@property(nonatomic, assign) NSUInteger page;

/** 为请求任务设置pageSize参数 */
@property(nonatomic, assign) NSUInteger pageSize;


/**
 *  将请求任务的page参数-1
 *  保证page最小为1
 */
- (void)minusPage;

@end
