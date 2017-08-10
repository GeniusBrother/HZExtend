//
//  NSObject+HZURLHandler.h
//  HZURLManager <https://github.com/GeniusBrother/HZURLManager>
//
//  Created by GeniusBrother on 2017/7/28.
//  Copyright (c) 2017 GeniusBrother. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HZURLHandler.h"
@interface NSObject (HZURLHandler)

+ (id<HZURLHandler> )urlHandlerForURL:(NSURL *)url;

@end
