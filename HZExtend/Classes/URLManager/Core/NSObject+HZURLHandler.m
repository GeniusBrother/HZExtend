//
//  NSObject+HZURLHandler.m
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2017/7/28.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import "NSObject+HZURLHandler.h"
#import "HZURLManagerConfig.h"
@implementation NSObject (HZURLHandler)

//获取URL对应的URLHandler
+ (id<HZURLHandler>)urlHandlerForURL:(NSURL *)url
{
    NSDictionary *config = [HZURLManagerConfig sharedConfig].urlMethodConfig;
    NSAssert(config, @"请先配置URL-Method-Config");
    
    NSString *host = url.host;
    NSString *path = url.path;
    NSString *scheme = url.scheme;
    NSString *pathContainHost = [NSString stringWithFormat:@"%@%@%@",scheme?[NSString stringWithFormat:@"%@://",scheme]:@"",host?:@"",path?:@""];
    NSString *className = [config objectForKey:pathContainHost];
    if (className) {
        Class class = NSClassFromString(className);
        return class != NULL?[[class alloc] init]:nil;
    }else {
        return nil;
    }
}

@end
