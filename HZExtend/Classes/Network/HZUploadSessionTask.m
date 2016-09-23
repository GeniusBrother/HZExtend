//
//  UploadSessionTask.m
//  ZHFramework
//
//  Created by xzh. on 15/8/20.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZUploadSessionTask.h"
#import "HZMacro.h"
@implementation HZUploadSessionTask

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadInit];
    }
    return self;
}

- (void)loadInit
{
    self.cached = NO;
}

- (void)setFileName:(NSString *)fileName formName:(NSString *)formName mimeType:(NSString *)mimeType
{
    self.formName = formName;
    self.fileName = fileName;
    self.mimeType = mimeType;
    
    _fileURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:nil];
}

- (void)setFileData:(NSData *)fileData formName:(NSString *)formName fileName:(NSString *)fileName mimeType:(NSString *)mimeType
{
    self.fileData = fileData;
    self.formName = formName;
    self.fileName = fileName;
    self.mimeType = mimeType;
}

- (void)dealloc
{
    HZLog(@"%@释放了",self);
}

@end
