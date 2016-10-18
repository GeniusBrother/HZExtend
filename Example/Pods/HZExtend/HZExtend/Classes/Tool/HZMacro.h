//
//  HZMacro.h
//  Pods
//
//  Created by xzh on 16/8/22.
//
//

#ifndef HZMacro_h
#define HZMacro_h

//对象
#define HZNotificationCenter [NSNotificationCenter defaultCenter]
#define HZUserDefaults [NSUserDefaults standardUserDefaults]
#define HZSharedApplication [UIApplication sharedApplication]
#define HZMainBundle [NSBundle mainBundle]
#define HZMainScreen [UIScreen mainScreen]

//常用数值
#define HZTabBarHeight 49.0f
#define HZNavBarHeight 64.0f

//引用
#define HZWeakObj(Obj) __weak typeof(Obj) weak##_##Obj = Obj
#define HZStrongObj(Obj) __strong typeof(weak##_##Obj) strong##_##Obj = weak##_##Obj

//路径
#define HZAssetPath(fileName) [[NSBundle mainBundle] pathForResource:fileName ofType:nil]
#define HZDocumentPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

#define HZLocalString(key) NSLocalizedString(key, nil)

#define HZNowTimeStamp (long long)[[[NSDate alloc] init] timeIntervalSince1970]

//返回属性字符串，结合HZObserver使用
#define HZKeyPath(keyPath) NSStringFromSelector(@selector(keyPath))

//颜色
#define HZRGB(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#define HZRGBA(R,G,B,A)	[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

//屏幕信息
#define HZDeviceWidth ([[UIScreen mainScreen] bounds].size.width)
#define HZDeviceHeight ([[UIScreen mainScreen] bounds].size.height)

//断言
#define HZAssertNoReturn(condition, msg) \
if (condition) {\
HZLog(@"%@",msg);\
return;\
}

#define HZAssertReturn(condition, msg, returnValue) \
if (condition) {\
HZLog(@"%@",msg);\
return returnValue;\
}

//限内部使用
#ifdef DEBUG
#define HZLog(...) NSLog(__VA_ARGS__)
#else 
#define HZLog(...)
#endif


#endif /* HZMacro_h */
