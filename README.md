##HZExtend##
####本项目交流群:32272635
####欢迎有兴趣的有好的想法的同学参与到项目中来，如果有问题请大家加入群中留言或者issue我，或者发邮件给我zuohong_xie@163.com

本项目特点<br/>
1.基于MVVM的思想，将数据处理放入ViewModel里从而减少控制器的压力，降低代码耦合.<br/>
2.基于AFN自定义了贴切业务逻辑的网络请求框架.<br/>
3.基于TMCache定制与业务逻辑相符的缓存体系.<br/>
4.基于FMDB实现了与表元组对应的数据模型.<br/>
5.一些常用的基础类扩展.<br/>

##一.MVVM&网络请求##
基本思路:网络请求基于SessionTask、HZNetwork(任务执行器)、NetworkConfig组成
####NetworkConfig
1.Duty:全局参数配置<br/>
2.使用:<br/>
>1.配置接口的共同URL、状态码路径,消息路径以及正确的状态码:<br/>
[[NetworkConfig sharedConfig] setupBaseURL:@"http://v5.api.xxx" codeKeyPath:@"code" msgKeyPath:@"msg" userAgent:@"IOS" rightCode:0];

>2.配置全局请求头<br/>
[[NetworkConfig sharedConfig] addDefaultHeaderFields:@{@"key":@"value"}];

>3.网络状态<br/>
[NetworkConfig sharedConfig].reachable  //程序刚启动时有0.02的网络状态延迟判断。故请求应在0.02s后再发出

####SessionTask
1.Duty:输入参数，输出数据<br/>
2.使用:<br/>
>1.初始化<br/>
//ViewModel<br/>
@interface FrameworkViewModel : HZViewModel<br/>
@property(nonatomic, strong) SessionTask *task;<br/>
@property(nonatomic, strong) UploadSessionTask *uploadTask;<br/>
@property(nonatomic, strong) NSMutableArray *recArray;<br/>
@end<br/>

@implementation FrameworkViewModel<br/>
- (void)loadViewModel //子类重新<br/>
{<br/>
    [super loadViewModel];<br/>

    _recTask = [SessionTask taskWithMethod:@"GET" path:@"/party/pooks-rank" params:[NSMutableDictionary dictionaryWithObjectsAndKeys:@1,kNetworkPage,MC_PAGE_SIZE,kNetworkPageSize, nil] delegate:self requestType:@"rank"];<br/>
    self.recTask.importCacheOnce = NO;  //默认为导入一次,但在分页模型中多次尝试导入缓存来使每次分页数据快速到达<br/>
    self.recTask.pathkeys = @[kNetworkPage,kNetworkPageSize];   //设置后支持支持http://baseURL/path/value1/value2类型请求<br/>
}<br/>

//加载数据的回调<br/>
- (void)loadDataWithTask:(SessionTask *)task type:(NSString *)type<br/>
{<br/>
    if([type isEqualToString:@"rank"]) {<br/>
        _pageData = [PageModel modelWithDic:task.responseObject]; //设置当前页的数据模型<br/>
        [self pageArray:@"recArray" appendArray:self.pageData.list task:task];  //追加分页数据<br/>
    }<br/>
}<br/>

//请求失败的回调,请求失败，无网失败<br/>
- (void)requestFailWithTask:(SessionTask *)task type:(NSString *)type<br/>
{<br/>
    [self pageDecrease:task]; //将当前页减一<br/>
}<br/>
@end<br/>

//VC<br、>
@implementation DiscoverPookScene<br/>

- (void)viewDidLoad<br/>
{<br/>
     _viewModel = [MorePookViewModel viewModelWithDelegate:self];<br/>
     [self.viewModel sendTask:self.viewModel]; //发送请求<br/>
}<br/>

//网络状态回调<br/>
//最终的请求结果到来调用(失败或成功)<br/>
- (void)viewModelConnetedNotifyForTask:(SessionTask *)task type:(NSString *)type<br/>
{<br/>
    if (task.succeed) {<br/>
        [self.tableView reloadData];<br/>
    }else {<br/>
        [self showFailWithText:task.message yOffset:0];<br/>
    }<br/>
}<br/>

//本地缓存数据到来调用(多种状态)(第一次再页面显示之前就会回调)<br/>
- (void)viewModelSendingNotifyForTask:(SessionTask *)task type:(NSString *)type<br/>
{<br/>
    if (task.cacheSuccess) [self.tableView reloadData];<br/>
}<br/>

//无网情况下缓存数据到来调用(多种状态)(第一次再页面显示之前就会回调)<br/>
- (void)viewModelLostedNotifyForTask:(SessionTask *)task type:(NSString *)type<br/>
{<br/>
    if (task.cacheSuccess) {<br/>
        [self.tableView reloadData];<br/>
    }<br/>
}<br/>

@end<br/>

##二.数据模型##
基本思路:模型的字段与表字段一一对应
####HZModel
1.Duty:全局参数配置<br/>
2.使用:<br/>
>1.继承HZModel然后初始化以Friend为例:<br/>
Friend *friend = [Friend modelWithDic:@"name":@"xzh3",@"age":@20,@"email":@"6540"];<br/>
>2.基本的数据库操作:<br/>
[Friend open];  //任何数据库操作都应先打开数据库，然后再关闭<br/>
[Friend close];<br/>
[Friend excuteUpdate:@"insert into Friend(name,age) values(?,?)" withParams:@[@"xzh",@20]]; //除查询外的任何操作<br/>
NSArray *select = [Friend excuteQuery:@"select *from Friend" withParams:nil];<br/>
for (NSDictionary *f in select) {<br/>
    NSLog(@"%@---%@----%@",[f objectForKey:@"name"],[f objectForKey:@"age"],[f objectForKey:@"email"]);<br/>
}<br/>
NSInteger count = [Friend longForQuery:@"select count(*) from Friend"];   //查询整数型的数据如count<br/>

>2.元组数据操作:<br/>
>2.1增删改:<br/>
[Friend safeSave];  //safe代表执行之前先open数据库，执行完毕后再close数据库<br/>
[Friend safeDelete];<br/>

>2.2查询(返回都是该模型)<br/>
+ (instancetype)modelWithSql:(NSString *)sql withParameters:(NSArray *)parameters;<br/>
+ (NSArray *)findByColumn:(NSString *)column value:(id)value;<br/>
+ (NSArray *)findWithSql:(NSString *)sql withParameters:(NSArray *)parameters;<br/>
+ (NSArray *)findAll;<br/>
NSArray *select = [Friend findWithSql:@"select *from Friend" withParameters:nil];<br/>
for (Friend *f in select) {<br/>
    NSLog(@"%@---%ld----%@",f.name,f.age,f.email);<br/>
}<br/>

>2.3数据库操作前后的回调，交由子类重写<br/>
- (void)loadModel;  //初始化配置(成员变量，或数组对象类设置)<br/>
- (void)beforeSave;<br/>
- (void)afterSave;<br/>
- (void)beforeUpdateSelf;<br/>
- (void)afterUpdateSelf;<br/>
- (void)beforeDeleteSelf;<br/>
- (void)afterDeleteSelf;<br/>
