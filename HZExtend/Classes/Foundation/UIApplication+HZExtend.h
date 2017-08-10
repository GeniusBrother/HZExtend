//
//  UIApplication+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 2017/8/4.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIApplication`.
 */
@interface UIApplication (HZExtend)

/** The Path of app's sandbox. */
@property (nonatomic, readonly) NSURL *rootURL;
@property (nonatomic, readonly) NSString *rootPath;

/** The Path of "Documents" folder in this app's sandbox. */
@property (nonatomic, readonly) NSURL *documentsURL;
@property (nonatomic, readonly) NSString *documentsPath;

/** The Path of "Caches" folder in this app's sandbox. */
@property (nonatomic, readonly) NSURL *cachesURL;
@property (nonatomic, readonly) NSString *cachesPath;

/** The Path of "Library" folder in this app's sandbox. */
@property (nonatomic, readonly) NSURL *libraryURL;
@property (nonatomic, readonly) NSString *libraryPath;

/** Application's Bundle Name.*/
@property (nullable, nonatomic, readonly) NSString *appBundleName;

/** Application's Bundle ID. */
@property (nullable, nonatomic, readonly) NSString *appBundleID;

/** Application's Bundle Identifier. */
@property (nullable, nonatomic, readonly) NSString *appBundleIdentifier;

/** Application's Version.*/
@property (nullable, nonatomic, readonly) NSString *appVersion;

/** Application's Build number. */
@property (nullable, nonatomic, readonly) NSString *appBuildVersion;

@end

NS_ASSUME_NONNULL_END
