//
//  HZURLNavigation.h
//  HZFoundation <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2015/8/21.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HZURLNavigation : NSObject
/**
 Returns the current UIViewController.
 */
+ (UIViewController *)currentViewController;

/**
 Returns the current UINavigationController.
 */
+ (nullable UINavigationController *)currentNavigationViewController;

/**
  Pushes a view controller onto the current UINavigationController’s stack and updates the display.
 
 @param viewController The view controller to push onto the stack. This object cannot be a tab bar controller. If the view controller is already on the navigation stack, this method throws an exception.
 @param animated Specify YES to animate the transition or NO if you do not want the transition to be animated. You might specify NO if you are setting up the navigation controller at launch time.
 @param replace Specify YES to remove visibleViewController.
 */
+ (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated;
+ (void)pushViewControllerArray:(NSArray *)viewControllers animated:(BOOL)animated;

/**
 Presents a view controller modally.
 
 @param viewController The view controller to display over the current view controller’s content.
 @param animated Pass YES to animate the presentation; otherwise, pass NO.
 @param completion The block to execute after the presentation finishes.
 */
+ (void)presentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(void (^ __nullable)(void))completion;

/** 
 Dismisses current view controller.
 */
+ (void)dismissCurrentAnimated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
