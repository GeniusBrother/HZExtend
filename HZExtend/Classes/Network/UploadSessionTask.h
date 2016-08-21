//
//  UploadSessionTask.h
//  ZHFramework
//
//  Created by xzh. on 15/8/20.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "SessionTask.h"

NS_ASSUME_NONNULL_BEGIN

@interface UploadSessionTask : SessionTask

@property(null_unspecified, nonatomic, copy) NSString *mimeType;
@property(null_unspecified, nonatomic, copy) NSString *fileName;
@property(null_unspecified, nonatomic, copy) NSString *formName;
@property(null_unspecified, nonatomic, strong) NSData *fileData;
@property(null_unspecified, nonatomic, strong, readonly) NSURL *fileURL; //根据fileName生成


/**
 *  文件参数设置
 */
- (void)setFileName:(NSString *)fileName
           formName:(NSString *)formName
           mimeType:(NSString *)mimeType;

- (void)setFileData:(NSData *)fileData
           formName:(NSString *)formName
           fileName:(NSString *)fileName
           mimeType:(NSString *)mimeType;
@end

NS_ASSUME_NONNULL_END