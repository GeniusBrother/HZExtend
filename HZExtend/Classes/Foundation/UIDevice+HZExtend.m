//
//  UIApplication+HZExtend.m
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 2017/8/4.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import "UIDevice+HZExtend.h"
#import "NSString+HZExtend.h"
#include <sys/sysctl.h>
@implementation UIDevice (HZExtend)

#pragma mark - Properties
- (HZDeviceSizeType)sizeType
{
    if (![UIScreen instancesRespondToSelector:@selector(currentMode)]) return HZDeviceSizeTypeUnKnow;
    
    CGSize deviceSize = [[UIScreen mainScreen] currentMode].size;
    if (CGSizeEqualToSize(CGSizeMake(640, 960), deviceSize)) return HZDeviceSizeType35Inch;
    if (CGSizeEqualToSize(CGSizeMake(640, 1136), deviceSize)) return HZDeviceSizeType4Inch;
    if (CGSizeEqualToSize(CGSizeMake(750, 1334), deviceSize)) return HZDeviceSizeType47Inch;
    if (CGSizeEqualToSize(CGSizeMake(1242, 2208), deviceSize)) return HZDeviceSizeType55Inch;
    
    return HZDeviceSizeTypeUnKnow;
}

- (NSString *)platform
{
    size_t size;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *machine = malloc(size);
    
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    
    free(machine);
    
    return platform;
}

- (NSString *)UUID
{
    return [[self identifierForVendor] UUIDString];
}

- (BOOL)isJailBroken
{
#if TARGET_IPHONE_SIMULATOR
    return NO;
#else
    NSArray *paths = @[@"/Applications/Cydia.app",
                       @"/private/var/lib/apt/",
                       @"/private/var/lib/cydia",
                       @"/private/var/stash"];
    for (NSString *path in paths) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:path]) return YES;
    }
    
    FILE *bash = fopen("/bin/bash", "r");
    if (bash != NULL) {
        fclose(bash);
        return YES;
    }
    
    NSString *path = [NSString stringWithFormat:@"/private/%@", [NSString stringWithUUID]];
    if ([@"HZExtend" writeToFile : path atomically : YES encoding : NSUTF8StringEncoding error : NULL]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        return YES;
    }
    
    return NO;
#endif
    
}

- (BOOL)isPhone
{
    NSString *model = [self model];    
    return [model rangeOfString:@"iPhone"].length != 0;
}

- (BOOL)isPad
{
    NSString *model = [self model];
    return [model rangeOfString:@"iPad"].length != 0;
}

#pragma mark - Method
- (BOOL)systemVersionIsGreatThanOrEqualTo:(NSInteger)version
{
    return ([[self systemVersion] floatValue] >= version);
}

- (BOOL)systemVersionIsLessThan:(NSInteger)version
{
    return ([[self systemVersion] floatValue] < version);
}
@end
