//
//  UIResponder+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 17/2/26.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Provides extensions for `UIResponder`
 */
@interface UIResponder (HZExtend)

/**
 Deliveries UI message.
 
 @param sel A selector identifying the message to send.
 @param block The block to be executed when message's responder is found.
 
 Sample Code:
 
 //ItemView.h
 @protocol ItemViewUIMessage <NSObject>
    - (void)messageDidClick:(ItemView *)item;
 @end
 
 //Deliveried the message about clicking.
 [self deliveryMessageWithSelector:@selector(itemDidClick:) usingBlock:^(UIResponder<ItemViewUIMessage> * _Nonnull responder) {
    [reponder messageDidClick:self];
 }];
 
 //responder.m
 - (void)messageDidClick:(ItemView *)item
 {
    //do something.....
 }
 */
- (void)deliveryMessageWithSelector:(SEL)sel usingBlock:(void (^)(UIResponder *responder))block;

@end

NS_ASSUME_NONNULL_END
