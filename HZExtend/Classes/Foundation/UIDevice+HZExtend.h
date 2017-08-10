//
//  UIApplication+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 2017/8/4.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, HZDeviceSizeType) {
    HZDeviceSizeTypeUnKnow, // unknow size of device
    HZDeviceSizeType35Inch, // 3.5 inch
    HZDeviceSizeType4Inch,  // 4 inch
    HZDeviceSizeType47Inch, // 4.7 inch
    HZDeviceSizeType55Inch, // 5.5 inch
};

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIDevice`.
 */
@interface UIDevice (HZExtend)

/** The equipment size of the current device. */
@property(nonatomic, readonly) HZDeviceSizeType sizeType;

/** The equipment model of the current device. e.g @"iPhone9,1",@"iPad6,7"... */
@property(nonatomic, readonly) NSString *platform;

/** The UUID of the current device. */
@property(nonatomic, readonly) NSString *UUID;

/** Whether the device is jailbroken. */
@property(nonatomic, readonly) BOOL isJailBroken;

/** Whether the device is iPhone. */
@property(nonatomic, readonly) BOOL isPhone;

/** Whether the device is iPad. */
@property(nonatomic, readonly) BOOL isPad;

/**
 Returns a Boolean value that indicates whether the version of system is great than or eaqual to the version.
 
 @param version The version to compare to the system's version
 */
- (BOOL)systemVersionIsGreatThanOrEqualTo:(NSInteger)version;

/**
 Returns a Boolean value that indicates whether the version of system is less than the version.
 
 @param version The version to compare to the system's version
 */
- (BOOL)systemVersionIsLessThan:(NSInteger)version;

@end

NS_ASSUME_NONNULL_END
