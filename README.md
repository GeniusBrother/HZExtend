##HZExtend##
####本项目交流群:32272635
####欢迎有兴趣的有好的想法的同学参与到项目中来，如果有问题请大家加入群中留言或者issue我，或者发邮件给我zuohong_xie@163.com

##本项目特点##
```bash
1.解放VC:基于MVVM的思想，将数据处理放入ViewModel里从而减少控制器的压力，降低代码耦合.
2.网络请求:基于AFN自定义了贴切业务逻辑的网络请求框架.
3.缓存体系:基于TMCache定制与业务逻辑相符的缓存体系.
4.数据元组:基于FMDB实现了与表元组对应的数据模型.
5.一些常用的基础类扩展.
```

##添加##
```ruby
1.pod 'HZExtend'

2.可以下载classes文件直接添加到项目中
```
##一.MVVM&网络请求##
基本思路:网络请求基于SessionTask、HZNetwork(任务执行器)、NetworkConfig组成

####配置接口的共同URL、状态码路径,消息路径以及正确的状态码:
```objective-c
[[NetworkConfig sharedConfig] setupBaseURL:@"http://v5.api.xxx" codeKeyPath:@"code" msgKeyPath:@"msg" userAgent:@"IOS" rightCode:0];
```
![](https://dn-impluse.qbox.me/24833/A98E9B1750666D91E88D21AFDC5ABFA4.jpg)<br/>

####后台返回的数据无状态码路径(此时不会判断业务逻辑是否成功)
```objective-c
[[NetworkConfig sharedConfig] setupBaseURL:@"http://v5.api.xxx" userAgent:@"IOS"];<br/>
```

####配置全局请求头
```objective-c
[[NetworkConfig sharedConfig] addDefaultHeaderFields:@{@"key":@"value"}];
```

####网络状态
```objective-c
[NetworkConfig sharedConfig].reachable  //程序刚启动时有0.02的网络状态延迟判断。故请求应在0.02s后再发出
```

####SessionTask
```objective-c
@interface FrameworkViewModel : HZViewModel
@property(nonatomic, strong) SessionTask *task;
@property(nonatomic, strong) UploadSessionTask *uploadTask;
@property(nonatomic, strong) NSMutableArray *recArray;
@end

@implementation FrameworkViewModel
- (void)loadViewModel //子类重写
{
    [super loadViewModel];

    _recTask = [SessionTask taskWithMethod:@"GET" path:@"/party/pooks-rank" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@1,kNetworkPage,MC_PAGE_SIZE,kNetworkPageSize, nil] delegate:self requestType:@"rank"];
    self.recTask.importCacheOnce = NO;  //默认为导入一次,但在分页模型中多次尝试导入缓存来使每次分页数据都能从缓存中读取
    self.recTask.pathkeys = @[kNetworkPage,kNetworkPageSize];   //设置后支持支持http://baseURL/path/value1/value2类型请求
}

//加载数据的回调
- (void)loadDataWithTask:(SessionTask *)task type:(NSString *)type
{
    if([type isEqualToString:@"rank"]) {
        _pageData = [PageModel modelWithDic:task.responseObject]; //设置当前页的数据模型
        [self pageArray:@"recArray" appendArray:self.pageData.list task:task];  //追加分页数据
    }
}

//请求失败的回调,请求失败，无网失败
- (void)requestFailWithTask:(SessionTask *)task type:(NSString *)type
{
    [self pageDecrease:task]; //将当前页减一
}
@end

//VC
@implementation DiscoverPookScene

- (void)viewDidLoad
{
     _viewModel = [MorePookViewModel viewModelWithDelegate:self];
     [self.viewModel sendTask:self.viewModel]; //发送请求
}

//网络状态回调
//最终的请求结果到来调用(失败或成功)
- (void)viewModelConnetedNotifyForTask:(SessionTask *)task type:(NSString *)type
{
    if (task.succeed) {
        [self.tableView reloadData];
    }else {
        [self showFailWithText:task.message yOffset:0];
    }
}

//本地缓存数据到来调用(多种状态)(第一次再页面显示之前就会回调)
- (void)viewModelSendingNotifyForTask:(SessionTask *)task type:(NSString *)type
{
    if (task.cacheSuccess) [self.tableView reloadData];
}

//无网情况下缓存数据到来调用(多种状态)(第一次再页面显示之前就会回调)
- (void)viewModelLostedNotifyForTask:(SessionTask *)task type:(NSString *)type
{
    if (task.cacheSuccess) {
        [self.tableView reloadData];
    }
}

@end
```

##二.数据模型##
基本思路:模型的字段与表字段一一对应
####继承HZModel然后初始化以Friend为例:
```objective-c
Friend *friend = [Friend modelWithDic:@"name":@"xzh3",@"age":@20,@"email":@"6540"];
```
####基本的数据库操作:
```objective-c
[Friend open];  //任何数据库操作都应先打开数据库，然后再关闭
[Friend close];
[Friend excuteUpdate:@"insert into Friend(name,age) values(?,?)" withParams:@[@"xzh",@20]]; //除查询外的任何操作
NSArray *select = [Friend excuteQuery:@"select *from Friend" withParams:nil];
for (NSDictionary *f in select) {
    NSLog(@"%@---%@----%@",[f objectForKey:@"name"],[f objectForKey:@"age"],[f objectForKey:@"email"]);
}
NSInteger count = [Friend longForQuery:@"select count(*) from Friend"];   //查询整数型的数据如count
```
####元组数据操作:
```objective-c
/***************************************************增删改***************************************************/
[Friend safeSave];  //safe代表执行之前先open数据库，执行完毕后再close数据库
[Friend safeDelete];
```
####查询(返回都是该模型)
```objective-c
+ (instancetype)modelWithSql:(NSString *)sql withParameters:(NSArray *)parameters;
+ (NSArray *)findByColumn:(NSString *)column value:(id)value;
+ (NSArray *)findWithSql:(NSString *)sql withParameters:(NSArray *)parameters;
+ (NSArray *)findAll;
NSArray *select = [Friend findWithSql:@"select *from Friend" withParameters:nil];
for (Friend *f in select) {
    NSLog(@"%@---%ld----%@",f.name,f.age,f.email);
}
```

####数据库操作前后的回调，交由子类重写:
```objective-c
- (void)loadModel;  //初始化配置(成员变量，或数组对象类设置)
- (void)beforeSave;<br/>
- (void)afterSave;<br/>
- (void)beforeUpdateSelf;<br/>
- (void)afterUpdateSelf;<br/>
- (void)beforeDeleteSelf;<br/>
- (void)afterDeleteSelf;<br/>
```

##三.HUD提示##
基本思路:分为2种:1.添加到vc.view上,通过创建时key可以获得  2.添加到window.view上
####vc.view类型
```objective-c
/***************************************************请求场景***************************************************/
等待:[self showIndicatorWithText:@"请求中" forKey:@"request"];
请求成功:[self successWithText:@"请求成功" forKey:@"request"];
请求失败:[self failWithText:@"请求失败" forKey:@"request"];

/***************************************************提示场景***************************************************/
成功:[self showSuccessWithText:@"成功"];
失败:[self showFailWithText:@"失败"];
仅文字:[self showMessage:@"只显示文字"];
```
####window.view类型
```objective-c
/***************************************************请求场景***************************************************/
等待:[self showWindowIndicatorWithText:@"请求中"];
请求成功:[self successWithText:@"请求成功"];
请求失败:[self failWithText:@"请求失败"];

/***************************************************提示场景***************************************************/
成功:[self showWindowSuccessWithText:@"成功"];
失败:[self showWindowFailWithText:@"失败"];
仅文字:[self showWindowMessage:@"只显示文字"];
```
