//
//  HZURLRewrite.h
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2017/7/28.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 Provides rewrite rules for `HZURLManager`
 */
@interface HZURLRewrite : NSObject

+ (NSURL *)rewriteURLForURL:(NSURL *)url;

@end
