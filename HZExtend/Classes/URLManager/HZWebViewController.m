//
//  HZWebViewController.m
//  ZHFramework
//
//  Created by xzh. on 15/8/24.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZWebViewController.h"
#import "UIViewController+HZHUD.h"
#import "UIViewController+HZURLManager.h"
#import "NSString+HZExtend.h"
@interface HZWebViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) NSURL *URL;
@end

@implementation HZWebViewController

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        _URL = URL;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = [self.queryDic objectForKey:@"title"];
    if (title.isNoEmpty) {
        self.title = title;
    }
    
    _webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    _webView.delegate = self;
    [self.view addSubview:_webView];
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:self.URL]];
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self webViewIsloading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (!self.title.isNoEmpty)
    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
    [self webViewIsSuccess];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self webViewIsFail];
}

#pragma mark - CallBack
- (void)webViewIsloading
{
    if (![self.huds objectForKey:@"loading"]) {
        [self showIndicatorWithText:@"加载中..." forKey:@"loading"];
    }
}

- (void)webViewIsSuccess
{
    if ([self.huds objectForKey:@"loading"]) {
        [self successWithText:@"加载成功" image:@"success" forKey:@"loading"];
    }
}

- (void)webViewIsFail
{
    if ([self.huds objectForKey:@"loading"]) {
        [self failWithText:@"加载成功" image:@"error" forKey:@"loading"];
    }
}
@end
