//
//  HZConst.h
//  ZHFramework
//
//  Created by xzh. on 15/8/17.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef DEBUG  // 调试状态
// 打开LOG功能
#define HZLog(...) NSLog(__VA_ARGS__)
#else // 发布状态
// 关闭LOG功能
#define HZLog(...)
#endif

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


