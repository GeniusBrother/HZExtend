//
//  SubjectList.h
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZModel.h"
#import "Pagination.h"
@interface SubjectList : HZModel
@property(nonatomic, strong) NSArray *list;
@property(nonatomic, strong) Pagination *pagination;    //分页模型

@end
