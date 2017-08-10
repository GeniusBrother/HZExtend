# HZURLManager
使用URL进行导航跳转(support URL to navigate)
####本项目交流群:32272635
####欢迎有兴趣的有好的想法的同学参与到项目中来，如果有问题请大家加入群中留言或者issue我，或者发邮件给我zuohong_xie@163.com

##Preview##
![preview](Screenshoot/urlmanager.gif)

##添加##
```ruby
下载文件直接将URLManager文件夹添加到项目中
```

##其它资源##
* [简书论坛](http://www.jianshu.com/collection/ba017346481d)
* [HZExtend,快速开发项目的框架,结合了MVC和MVVM的优点](https://github.com/GeniusBrother/HZExtend)
* [HZMenuView,以UINavigationController为容器,且导航页面时不关闭的侧边栏](https://github.com/GeniusBrother/HZMenuView)

##一.URL配置##
```objective-c
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    /**
     *  URL配置
     *  URL的Host->class即 URL的host:Class of UIViewController
     */
    [HZURLManageConfig sharedConfig].config = @{
                                                @"hz://urlItemA":@"ViewController",
                                                @"hz://urlItemB":@"URLItemViewController"
                                                };
    //......                                            
}    
```
##二.跳转##
####push
```objective-c
//push hz://urlItemB 到对应的控制器,并传入参数title=push
[HZURLManager pushViewControllerWithString:@"hz://urlItemB?title=push" animated:YES];

//最后通过控制器的queryDic属性获取@{@“title”:@"push",@"key":@"value"},封装在UIViewController+HZURLManager.h
[HZURLManager pushViewControllerWithString:@"hz://urlItemB?title=push"" queryDic:@{@"key":@"value"} animated:YES];
```
####present
```objective-c
//push hz://urlItemB 到对应的控制器,并传入参数title=present
[HZURLManager presentViewControllerWithString:@"hz://urlItemB?title=present" animated:YES completion:nil];

//最后通过控制器的queryDic属性获取@{@“title”:@"present",@"key":@"value"},封装在UIViewController+HZURLManager.h
[HZURLManager presentViewControllerWithString:@"hz://urlItemB?title=push"" queryDic:@{@"key":@"value"} animated:YES completion:nil];
```
####Dissmiss
```objective-c
/**
 *  1.若当前控制器的容器为导航控制器,则pop
 *  2.若当前控制器为模态视图控制器,则dismiss
 */
[HZURLManager dismissCurrentAnimated:YES];
```

##三.其它##
####生成控制器
```objective-c
//根据URL创建控制器
UIViewController *rootViewCtrl = [UIViewController viewControllerWithString:@"hz://urlItemA"];
```

####获得当前控制器
```objective-c
UIViewController *currentViewCtrl = [HZURLNavigation currentViewController];
```

####获得当前的导航控制器
```objective-c
UINavigationController *currentNavCtrl = [HZURLNavigation currentNavigationViewController];
```

####参数传递
```objective-c
@interface UIViewController (HZURLManager)
/**
 *  由查询字符串和跳转时传入的NSDictionary组成
 */
@property(nonatomic, strong, readonly) NSDictionary *queryDic;

@end
```
