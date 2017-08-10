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
#define HZDevice [UIDevice currentDevice]

//常用数值
#define HZTabBarHeight 49.0f
#define HZNavBarHeight 64.0f
#define HZStatusBarHeight 20.0f

//引用
#define HZWeakObj(Obj) __weak typeof(Obj) weak##_##Obj = Obj
#define HZStrongObj(Obj) __strong typeof(weak##_##Obj) strong##_##Obj = weak##_##Obj

//路径
#define HZAssetPath(fileName) [[NSBundle mainBundle] pathForResource:fileName ofType:nil]

#define HZLocalString(key) NSLocalizedString(key, nil)

#define HZString(...) [NSString stringWithFormat:__VA_ARGS__]

//返回属性字符串，结合HZObserver使用
#define HZKeyPath(keyPath) NSStringFromSelector(@selector(keyPath))

//颜色
#define HZRGB(R,G,B) [UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]
#define HZRGBA(R,G,B,A)	[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

//屏幕信息
#define HZDeviceWidth ([[UIScreen mainScreen] bounds].size.width)
#define HZDeviceHeight ([[UIScreen mainScreen] bounds].size.height)

//限内部使用
#ifdef DEBUG
#define HZLog(format,...) printf("[%s] %s %s\n", __TIME__, __FUNCTION__, [[NSString stringWithFormat:format, ## __VA_ARGS__] UTF8String])
#else
#define HZLog(format,...)
#endif

NS_INLINE NSRange NSMakeRangeLen(NSRange range,NSInteger len) {
    NSRange r = range;
    r.length = len;
    return r;
}

NS_INLINE NSRange NSMakeRangeLoc(NSRange range,NSInteger loc) {
    NSRange r = range;
    r.location = loc;
    return r;
}

#endif /* HZMacro_h */
