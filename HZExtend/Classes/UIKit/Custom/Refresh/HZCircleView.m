//
//  HZCircleView.m
//  HZNetworkDemo
//
//  Created by xzh on 16/1/19.
//  Copyright © 2016年 xzh. All rights reserved.
//

#import "HZCircleView.h"
#import "HZMacro.h"
#import "UIColor+HZExtend.h"
@implementation HZCircleView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetStrokeColorWithColor(context, [UIColor colorForHex:0x49d2ff].CGColor);
    CGFloat startAngle = -M_PI/4;
    CGFloat step = 11*M_PI/6 * self.progress;
    CGContextAddArc(context, self.bounds.size.width/2, self.bounds.size.height/2, self.bounds.size.width/2-3, startAngle, startAngle+step, 0);
    CGContextStrokePath(context);
}

@end
