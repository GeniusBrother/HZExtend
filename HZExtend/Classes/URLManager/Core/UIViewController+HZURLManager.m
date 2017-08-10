//
//  UIViewController+HZURLManager.m
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 15/8/21.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//

#import "UIViewController+HZURLManager.h"
#import "HZURLManagerConfig.h"
#import <objc/runtime.h>

static const char kOriginURL = '\0';
static const char kParams = '\1';
@interface UIViewController ()

@property(nonatomic, strong) NSString *originURL;
@property(nonatomic, strong) NSDictionary *queryDic;

@end

@implementation UIViewController (HZURLManager)
#pragma mark - Public Method
#pragma mark Core
+ (UIViewController *)viewControllerForURL:(NSURL *)url params:(NSDictionary *)params
{
    NSDictionary *config = [HZURLManagerConfig sharedConfig].urlControllerConfig;
    NSAssert(config, @"请先配置URL-Ctrl-Config");
    
    NSString *scheme = url.scheme;
    
    
    if (!url || !config) return nil;
    
    /*******************根据scheme创建控制器********************/
    UIViewController *viewCtrl = nil;
    NSDictionary *ctrlsOfScheme = [config objectForKey:scheme];
    NSString *strClass = [ctrlsOfScheme objectForKey:[NSString stringWithFormat:@"%@%@",url.host?:@"",url.path]];
    NSString *errorInfo = nil;
    if(strClass) {    //判断配置文件里有无指定配置
        Class class = NSClassFromString(strClass);
        if(NULL != class) {
            viewCtrl = [[class alloc] init];
        }else { //无该控制器
            errorInfo = [NSString stringWithFormat:@"404 :) ,%@并无该类",strClass];
        }
    }else {
        if ([scheme isEqualToString:@"http"]||[scheme isEqualToString:@"https"]) {  //判断是否配置了默认的webViewController
            NSString *strWebCtrl = [HZURLManagerConfig sharedConfig].classOfWebViewCtrl;
            if (strWebCtrl) {
                Class class = NSClassFromString(strWebCtrl);
                viewCtrl = [[class alloc] initWithURL:url];
            }else {
                errorInfo = [NSString stringWithFormat:@"404 :) ,%@://%@并无注册",url.scheme,url.host];
            }

        }else { //shcheme为自定义
            errorInfo = [NSString stringWithFormat:@"404 :) ,%@://%@并无注册",url.scheme,url.host];
        }
    }
    
#ifdef DEBUG  // 调试状态
    viewCtrl = viewCtrl?:[self errorViewConrtollerWithInfo:errorInfo];
    
#else // 发布状态
#endif
    
    if (viewCtrl) {
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionary];
        NSDictionary *urlQueryDic = [self queryDicWithURL:url];
        if (urlQueryDic) [tmpDic addEntriesFromDictionary:urlQueryDic];
        if (params) [tmpDic addEntriesFromDictionary:params];
        viewCtrl.params = tmpDic;
        viewCtrl.originURL = url.absoluteString;
        viewCtrl.hidesBottomBarWhenPushed = [HZURLManagerConfig sharedConfig].hideBottomWhenPushed;
        return viewCtrl;
    }
    return nil;
}


+ (UIViewController *)viewControllerForURL:(NSURL *)url
{
    return [self viewControllerForURL:url params:nil];
}

#pragma mark - Private Method
/**
 *  创建错误控制器
 */
+ (UIViewController *)errorViewConrtollerWithInfo:(NSString *)errorInfo
{
    Class noCtrlClass = NSClassFromString(@"HZErrorViewController");
    UIViewController *viewCtrl = [[noCtrlClass alloc] init];
    [viewCtrl setValue:errorInfo forKey:@"errorInfo"];
    return viewCtrl;
}

+ (NSString *)valueFromKeyValue:(NSString *)keyValue atIndex:(NSUInteger)index
{
    return [[keyValue componentsSeparatedByString:@"="] objectAtIndex:index];
}

+ (NSDictionary *)queryDicWithURL:(NSURL *)url
{
    NSString *keyValues = url.query;
    if (!keyValues) return nil;
    
    return [self queryDicWithKeysValues:keyValues];
}


+ (NSDictionary *)queryDicWithKeysValues:(NSString *)keyValues
{
    if (!(keyValues.length > 0)) return @{};
    
    NSArray *pairArray = [keyValues componentsSeparatedByString:@"&"];  //键值对字符串
    NSMutableDictionary *queryDic= [NSMutableDictionary dictionaryWithCapacity:pairArray.count];
    NSString *key = nil;
    NSString *obj = nil;
    if (pairArray.count > 1)
    {
        for (NSString *pair in pairArray)
        {
            key = [self valueFromKeyValue:pair atIndex:0];
            obj = [self valueFromKeyValue:pair atIndex:1];
            [queryDic setObject:[obj stringByRemovingPercentEncoding] forKey:key];
        }
    }
    else if (pairArray.count == 1)
    {
        key = [self valueFromKeyValue:keyValues atIndex:0];
        obj = [self valueFromKeyValue:keyValues atIndex:1];
        [queryDic setObject:[obj stringByRemovingPercentEncoding] forKey:key];
    }
    
    return queryDic;
}

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

- (NSDictionary *)params
{
    return objc_getAssociatedObject(self, &kParams);
}

- (void)setParams:(NSDictionary *)params
{
    NSDictionary *dic = objc_getAssociatedObject(self, &kParams);
    if (dic != params) {
        [self willChangeValueForKey:@"params"];
        objc_setAssociatedObject(self, &kParams, params, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"params"];
    }
}


@end
