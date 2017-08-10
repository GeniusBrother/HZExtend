//
//  HZURLHandler.h
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2017/7/28.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol HZURLHandler <NSObject>
/**
 Handle URL.
 
 @discussion You can make different responses depending on the URL.
 
 @param URL The URL corresponding to the module method.
 @param target The object of using HZURLManager
 @param params Additional parameters passed to URLHandler
 */
- (id)handleURL:(NSURL *)url withTarget:(id)target withParams:(nullable id)params;

@end

NS_ASSUME_NONNULL_END
