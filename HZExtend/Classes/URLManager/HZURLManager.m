//
//  HZURLManager.m
//  ZHFramework
//
//  Created by xzh. on 15/8/21.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZURLManager.h"
#import "NSObject+HZExtend.h"
#import "HZURLHandler.h"
@interface HZURLManager ()

@property(nonatomic, copy) NSDictionary *urlControllerConfig;
@property(nonatomic, copy) NSDictionary *urlMethodConfig;
@property(nonatomic, strong) NSMutableArray *rewriteRule;

@end

@implementation HZURLManager
#pragma mark - Initialization
singleton_m
+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            _rewriteRule = [NSMutableArray array];
        });
    }
    return self;
}

- (void)loadURLCtrlConfig:(NSString *)ctrlPath urlMethodConfig:(NSString *)methodPath
{
    if (ctrlPath.isNoEmpty) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:ctrlPath]) {
            self.urlControllerConfig = [NSDictionary dictionaryWithContentsOfFile:ctrlPath];
        }else {
            NSAssert(NO, @"ctrlPath should be a file path");
        }
    }
    
    if (methodPath.isNoEmpty) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:methodPath]) {
            self.urlMethodConfig = [NSDictionary dictionaryWithContentsOfFile:methodPath];
        }else {
            NSAssert(NO, @"methodPath should be a file path");
        }
    }
}

- (void)addRewriteRules:(NSArray *)rule
{
    if (rule.isNoEmpty)
    [self.rewriteRule addObjectsFromArray:rule];
}

#pragma mark - Public Method
- (id)handleURL:(NSString *)url withTarget:(id)target withParams:(nullable id)parmas
{
    if (!url.isNoEmpty) return nil;
    
    NSAssert(self.urlMethodConfig.isNoEmpty, @"请先配置URL-Method-Config");
    
    NSURL *formatedURL = [self formatedURL:url];
    id<HZURLHandler> handler = [self urlHandlerForURL:formatedURL];
    if (handler) {
        return [handler handleURL:formatedURL.absoluteString withTarget:target withParams:parmas];
    }
    
    return nil;
}

- (void)redirectToURL:(NSString *)url
             animated:(BOOL)animated
               parmas:(nullable NSDictionary *)parmas
              options:(nullable NSDictionary *)options
           completion:(nullable HZVoidBlock)completion
{
    NSAssert(self.urlControllerConfig.isNoEmpty, @"请先配置URL-Ctrl-Config");
    
    NSURL *formatedURL = [self formatedURL:url];
    NSURL *rewritedURL = [self rewriteURLForURL:formatedURL];
    
}

- (void)redirectToURL:(NSString *)url animated:(BOOL)animated
{
    [self redirectToURL:url animated:animated parmas:nil options:nil completion:nil];
}

- (void)redirectToURL:(NSString *)url animated:(BOOL)animated params:(nullable NSDictionary *)params
{
    [self redirectToURL:url animated:animated parmas:params options:nil completion:nil];
}

#pragma mark - Private Method
//格式化URL
- (NSURL *)formatedURL:(NSString *)url
{
    if (!url.isNoEmpty) return nil;
    
    NSString *formatedURLString = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    return [NSURL URLWithString:formatedURLString];
}

//获取URL对应的URLHandler
- (id<HZURLHandler>)urlHandlerForURL:(NSURL *)url
{
    NSString *host = url.host;
    NSString *path = url.path;
    NSString *scheme = url.scheme;
    NSString *pathContainHost = [NSString stringWithFormat:@"%@://%@%@",scheme.isNoEmpty?scheme:@"",host.isNoEmpty?host:@"",path.isNoEmpty?path:@""];
    NSString *className = [self.urlMethodConfig objectForKey:pathContainHost];
    if (className.isNoEmpty) {
        Class class = NSClassFromString(className);
        return class != NULL?[[class alloc] init]:nil;
    }else {
        return nil;
    }
}

//获取重写URL
- (NSURL *)rewriteURLForURL:(NSURL *)url
{
    if (!url) return nil;
    
    if (self.rewriteRule.isNoEmpty) {
        NSString *targetURL = url.absoluteString;
        NSRegularExpression *replaceRx = [NSRegularExpression regularExpressionWithPattern:@"[$](\\d)+|[$]query" options:0 error:NULL];
        for (NSDictionary *rule in self.rewriteRule) {
            NSString *matchRule = [rule objectForKey:@"match"];
            if (!matchRule.isNoEmpty) continue;
            
            NSRange searchRange = NSMakeRange(0, targetURL.length);
            NSRegularExpression *rx = [NSRegularExpression regularExpressionWithPattern:matchRule options:0 error:NULL];
            NSRange range = [rx rangeOfFirstMatchInString:targetURL options:0 range:searchRange];
            if (range.length != 0) {    //url匹配
                //获取分组值
                NSMutableArray *groupValues = [NSMutableArray array];
                NSTextCheckingResult *result = [rx firstMatchInString:targetURL options:0 range:searchRange];
                for (NSInteger idx = 0; idx<rx.numberOfCaptureGroups; idx++) {
                    NSRange groupRange = [result rangeAtIndex:idx+1];
                    if (groupRange.length != 0) {
                        [groupValues addObject:[targetURL substringWithRange:groupRange]];
                    }
                }
                
                //拼接目标字符串
                NSString *targetRule = [rule objectForKey:@"target"];
                NSMutableString *newTargetURL = [NSMutableString stringWithString:targetRule];
                [replaceRx enumerateMatchesInString:targetRule options:0 range:NSMakeRange(0, targetRule.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                    NSRange matchRange = result.range;
                    NSRange firstGroupRange = [result rangeAtIndex:1];
                    if (firstGroupRange.length != 0) {
                        NSInteger index = [[targetRule substringWithRange:firstGroupRange] integerValue] - 1;
                        if (index >= 0 && index < groupValues.count) {
                            [newTargetURL replaceCharactersInRange:matchRange withString:groupValues[index]];
                        }
                    }else {
                        NSString *value = [targetRule substringWithRange:matchRange];
                        if ([value containsString:@"query"]) {
                            [newTargetURL replaceCharactersInRange:matchRange withString:url.query.isNoEmpty?url.query:@""];
                        }
                    }
                }];
            }
            
            targetURL = newTargetURL;
        }
    }
    
    return url;
}



@end


@implementation HZURLManager (URLManagerDeprecated)

#pragma mark - push
+ (void)pushViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerWithString:urlstring];
    if (viewController)
        [HZURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerWithString:urlstring queryDic:query];
    if (viewController)
        [HZURLNavigation pushViewController:viewController animated:animated];
}

+ (void)pushViewController:(UIViewController *)ctrl animated:(BOOL)animated
{
    [HZURLNavigation pushViewController:ctrl animated:animated];
}

#pragma mark - Present
+ (void)presentViewControllerWithString:(NSString *)urlstring animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerWithString:urlstring];
    if (viewController)
        [HZURLNavigation presentViewController:viewController animated:animated completion:completion];
}

+ (void)presentViewControllerWithString:(NSString *)urlstring queryDic:(NSDictionary *)query animated:(BOOL)animated completion:(void (^ _Nullable)(void))completion
{
    if (!urlstring.isNoEmpty) return;
    
    UIViewController *viewController = [UIViewController viewControllerWithString:urlstring queryDic:query];
    if (viewController)
        [HZURLNavigation presentViewController:viewController animated:animated completion:completion];
}

+ (void)presentViewController:(UIViewController *)ctrl animated:(BOOL)animated completion:(void (^)(void))completion
{
    [HZURLNavigation presentViewController:ctrl animated:animated completion:completion];
}


+ (void)dismissCurrentAnimated:(BOOL)animated
{
    [HZURLNavigation dismissCurrentAnimated:animated];
}

@end
