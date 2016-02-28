//
//  AppDelegate.m
//  HZExtend-Demo
//
//  Created by xzh on 16/2/13.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "AppDelegate.h"
#import "NetworkConfig.h"
#import "AFNetworkReachabilityManager.h"
#import "HZURLManageConfig.h"
#import "HZNavigationController.h"
#import "ExampleItemViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"unkonw");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"无法连接");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                NSLog(@"蜂窝");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"wifi");
                break;
                
            default:
                break;
        }
    }];
    
    /**
     *  要使请求框架正常工作，必须要监听
     */
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[NetworkConfig sharedConfig] setupBaseURL:@"http://v5.api.maichong.me" codeKeyPath:@"code" msgKeyPath:@"msg" userAgent:@"IOS" rightCode:0];
    
    [HZURLManageConfig sharedConfig].config = @{
                                                @"hz://network":@"ViewController",
                                                @"hz://urlmanager":@"URLViewController",
                                                @"hz://urlItem":@"URLItemViewController"
                                                };
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[HZNavigationController alloc] initWithRootViewController:[[ExampleItemViewController alloc] init]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
