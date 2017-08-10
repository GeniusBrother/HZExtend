#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "HZMacro.h"
#import "HZSingleton.h"
#import "NSArray+HZExtend.h"
#import "NSData+HZExtend.h"
#import "NSDate+HZExtend.h"
#import "NSDictionary+HZExtend.h"
#import "NSObject+HZExtend.h"
#import "NSString+HZExtend.h"
#import "NSTimer+HZExtend.h"
#import "NSURL+HZExtend.h"
#import "UIApplication+HZExtend.h"
#import "UIColor+HZExtend.h"
#import "UIDevice+HZExtend.h"
#import "UIView+HZExtend.h"
#import "HZFoundation.h"

FOUNDATION_EXPORT double HZFoundationVersionNumber;
FOUNDATION_EXPORT const unsigned char HZFoundationVersionString[];

