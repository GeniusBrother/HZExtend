//
//  HzSystem.h
//  ZHFramework
//
//  Created by xzh. on 15/7/23.
//  Copyright (c) 2015年 xzh. All rights reserved.
//
#define HZDeviceWidth [[UIScreen mainScreen] bounds].size.width
#define HZDeviceHeight [[UIScreen mainScreen] bounds].size.height
#import <Foundation/Foundation.h>
@interface HZSystem : NSObject

/********系统********/
+ (BOOL)isIOS6Later;    //include
+ (BOOL)isIOS7Later;
+ (BOOL)isIOS8Later;
+ (BOOL)isIOS9Later;

+ (BOOL)isIOS6Early;    //don't include
+ (BOOL)isIOS7Early;
+ (BOOL)isIOS8Early;
+ (BOOL)isIOS9Early;

/********型号********/
+ (BOOL)isIPhone35Inch;
+ (BOOL)isIPhone4Inch;
+ (BOOL)isIPhone47Inch;
+ (BOOL)isIPhone55Inch;
+ (BOOL)isIPhone4InchEarly; //include

/********Device Info********/
+ (NSString *)systemVersion;
+ (NSString *)platform;
+ (NSString *)UUID;
+ (BOOL)isJailBroken;
+ (BOOL)isPhone;
+ (BOOL)isPad;

/********APP Info********/
+ (NSString *)appVersion;
+ (NSString *)appIdentifier;
+ (NSString *)systemInfo;

@end
