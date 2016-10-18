//
//  HZSessionTask+Params.m
//  HZExtend
//
//  Created by xzh on 2016/10/18.
//  Copyright © 2016年 GeniusBrother. All rights reserved.
//

#import "HZSessionTask+Params.h"

@implementation HZSessionTask (Params)
- (void)setPage:(NSUInteger)page
{
    [self.params setValue:@(page) forKey:kNetworkPage];
}

- (void)setPageSize:(NSUInteger)pageSize
{
    [self.params setValue:@(pageSize) forKey:kNetworkPageSize];
}

- (NSUInteger)page
{
    NSNumber *page = [self.params objectForKey:kNetworkPage];
    return [page integerValue];
}

- (NSUInteger)pageSize
{
    NSNumber *pageSize = [self.params objectForKey:kNetworkPageSize];
    
    return pageSize?[pageSize integerValue]:20; //默认为20
}

- (void)minusPage
{
    NSNumber *oldNumber = [self.params objectForKey:kNetworkPage];
    if (oldNumber.integerValue >=2) self.page = oldNumber.integerValue - 1;
}

@end
