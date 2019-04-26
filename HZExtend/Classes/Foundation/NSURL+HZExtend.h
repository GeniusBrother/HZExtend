//
//  NSURL+HZExtend.h
//  HZFoundation <https://github.com/GeniusBrother/HZFoundation>
//
//  Created by GeniusBrother on 15/8/21.
//  Copyright (c) 2015 GeniusBrother. All rights reserved.
//
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 Provides extensions method for `NSURL`.
 */
@interface NSURL (HZExtend)

/** Returns absoluteString but not contain the part of query. */
@property(nonatomic, readonly) NSString *allPath;

/** Boolean value that indicates whether the resource from remote. */
@property(nonatomic, readonly) BOOL isRemote;

/**
 Return a Dictionary which contains query params
 */
- (nullable NSDictionary *)queryDic;



@end

NS_ASSUME_NONNULL_END
