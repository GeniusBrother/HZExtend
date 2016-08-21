//
//  SubjectDay.h
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZModel.h"

@interface SubjectDay : HZModel
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *link;
@property(nonatomic, strong) NSNumber *createdat;
@property(nonatomic, strong) NSArray *items;
@end
