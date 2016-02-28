//
//  UIViewController+HZURLManager.m
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "UIViewController+HZURLManager.h"
#import "NSURL+HZExtend.h"
#import "NSObject+HZExtend.h"
#import "NSString+HZExtend.h"
#import "HZWebViewController.h"
#import <objc/runtime.h>

static const char kOriginURL = '\0';
static const char kQueryDic = '\1';
@interface UIViewController ()

@property(nonatomic, strong) NSString *originURL;
@property(nonatomic, strong) NSDictionary *queryDic;

@end

@implementation UIViewController (HZURLManager)
#pragma mark 创建控制器
/**
 *  根据URL创建对应的控制器
 *  目前只返回一个控制器,以后可能会扩展返回多个控制器
 */
+ (NSArray *)viewControllersWithURL:(NSString *)urlstring queryDic:(NSDictionary *)queryDic
{
    NSString *scheme = urlstring.scheme;
    NSDictionary *config = [HZURLManageConfig sharedConfig].config;
    if (!urlstring.isNoEmpty || !config.isNoEmpty) return nil;

    /*******************根据schema创建控制器********************/
    UIViewController *viewCtrl = nil;
    if ([scheme isEqualToString:@"http"]||[scheme isEqualToString:@"https"]) {  //schema为http
        NSString *strWebCtrl = [HZURLManageConfig sharedConfig].classOfWebViewCtrl.isNoEmpty?[HZURLManageConfig sharedConfig].classOfWebViewCtrl:@"HZWebViewController";
        Class class = NSClassFromString(strWebCtrl);
        viewCtrl = [[class alloc] initWithURL:[NSURL URLWithString:urlstring]];
    }else { //shchema为自定义
        NSString *strclass = [config objectForKey:urlstring.allPath];
        if(strclass.isNoEmpty) {
            Class class = NSClassFromString(strclass);
            viewCtrl = [[class alloc] init];
        }
    }
    
    if (viewCtrl) {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        NSDictionary *urlQueryDic = urlstring.queryDic;
        if (urlQueryDic.isNoEmpty) [tmpDic addEntriesFromDictionary:urlQueryDic];
        if (queryDic.isNoEmpty) [tmpDic addEntriesFromDictionary:queryDic];
        viewCtrl.queryDic = tmpDic;
        viewCtrl.originURL = urlstring;
        return @[viewCtrl];
    }
    return nil;
}

#pragma mark - Public Method
+ (UIViewController *)viewControllerWithString:(NSString *)urlstring
{
    return [[self viewControllersWithURL:urlstring queryDic:nil] firstObject];
}

+ (UIViewController *)viewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query
{
    return [[self viewControllersWithURL:urlstring queryDic:query] firstObject];
}

//#pragma mark - Private
//+ (NSArray *)allPaths:(NSURL *)URL
//{
//    if (!URL.absoluteString.isNoEmpty) return nil;
//    
//    if (URL.path.isNoEmpty) {
//        NSArray *pathArray = [URL.pathComponents subarrayWithRange:NSMakeRange(1, URL.pathComponents.count-1)];
//        NSString *host = URL.host;
//        if (host.isNoEmpty) return [@[host] arrayByAddingObjectsFromArray:pathArray];
//    }else {
//        NSString *path = URL.host;
//        if (path.isNoEmpty) return @[path];
//        
//    }
//    
//    return nil;
//}

#pragma mark - Property
- (NSString *)originURL
{
    return objc_getAssociatedObject(self, &kOriginURL);
}

- (void)setOriginURL:(NSString *)originURL
{
    NSString *url = objc_getAssociatedObject(self, &kOriginURL);
    if (url != originURL) {
        [self willChangeValueForKey:@"originURL"];
        objc_setAssociatedObject(self, &kOriginURL, originURL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"originURL"];
    }
}

- (NSDictionary *)queryDic
{
    return objc_getAssociatedObject(self, &kQueryDic);
}

- (void)setQueryDic:(NSDictionary *)queryDic
{
    NSDictionary *dic = objc_getAssociatedObject(self, &kQueryDic);
    if (dic != queryDic) {
        [self willChangeValueForKey:@"queryDic"];
        objc_setAssociatedObject(self, &kQueryDic, queryDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"queryDic"];
    }
}


@end
