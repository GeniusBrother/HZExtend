//
//  SubjectViewModel.h
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZViewModel.h"
#import "SubjectList.h"
@interface SubjectViewModel : HZViewModel
@property(nonatomic, strong) HZSessionTask *task;
@property(nonatomic, strong) NSMutableArray *subjectArray;
@property(nonatomic, strong) SubjectList *subjectList;

- (void)saveSubject;
@end
