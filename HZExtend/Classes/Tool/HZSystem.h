//
//  HzSystem.h
//  ZHFramework
//
//  Created by xzh. on 15/7/23.
//  Copyright (c) 2015年 xzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HZSystem : NSObject

/********系统********/
+ (BOOL)isIOS6Later;    //包括IOS6,下同
+ (BOOL)isIOS7Later;
+ (BOOL)isIOS8Later;
+ (BOOL)isIOS9Later;

+ (BOOL)isIOS6Early;    //不包括IOS6,下同
+ (BOOL)isIOS7Early;
+ (BOOL)isIOS8Early;
+ (BOOL)isIOS9Early;

/********尺寸********/
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
