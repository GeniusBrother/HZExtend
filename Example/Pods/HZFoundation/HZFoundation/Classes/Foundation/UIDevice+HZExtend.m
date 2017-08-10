//
//  UIDevice+HZExtend.m
//  Pods
//
//  Created by xzh on 2017/8/4.
//
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
    static const char * __jb_apps[] =
    {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    
    
    for ( int i = 0; __jb_apps[i]; ++i )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]] )
        {
            return YES;
        }
    }
    
    if ( [[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"] )
    {
        return YES;
    }
    
    if ( 0 == system("ls"))
    {
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
