//
//  HZWebViewController.h
//  ZHFramework
//
//  Created by xzh. on 15/8/24.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import "HZViewController.h"
@interface HZWebViewController : HZViewController

@property(nonatomic, strong, readonly) UIWebView *webView;
@property(nonatomic, strong, readonly) NSURL *URL;

- (instancetype)initWithURL:(NSURL *)URL;

/**
 *  子类重写来回调
 */
-(void)webViewIsloading;    //加载中调用
-(void)webViewIsSuccess;    //加载成功调用
-(void)webViewIsFail;       //加载失败调用

@end
