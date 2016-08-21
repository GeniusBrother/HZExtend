//
//  SubjectItem.h
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZModel.h"

@interface SubjectItem : HZModel

@property(nonatomic, copy) NSString *color;
@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, strong) NSNumber *tag;
@property(nonatomic, strong) NSNumber *createdat;


@end
