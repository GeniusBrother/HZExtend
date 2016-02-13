//
//  Pagination.h
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZModel.h"

@interface Pagination : HZModel
@property(nonatomic,retain)NSNumber *page;
@property(nonatomic,retain)NSNumber *pageSize;
@property(nonatomic,retain)NSNumber *total;
@property(nonatomic,retain)NSNumber *isEnd;
@end
