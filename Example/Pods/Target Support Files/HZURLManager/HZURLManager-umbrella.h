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

#import "HZErrorViewController.h"
#import "HZNavigationController.h"
#import "HZURLHandler.h"
#import "HZURLManager.h"
#import "HZURLManagerConfig.h"
#import "HZURLNavigation.h"
#import "HZURLRewrite.h"
#import "NSObject+HZURLHandler.h"
#import "UIViewController+HZURLManager.h"

FOUNDATION_EXPORT double HZURLManagerVersionNumber;
FOUNDATION_EXPORT const unsigned char HZURLManagerVersionString[];

