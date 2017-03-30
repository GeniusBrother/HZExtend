//
//  UITextView+HZExtend.m
//  Pods
//
//  Created by xzh on 2017/3/29.
//
//

#import "UITextView+HZExtend.h"
#import <objc/runtime.h>
@implementation UITextView (HZExtend)

- (UILabel *)placeholderLabel
{
    UILabel *placeHolderLabel = [self valueForKey:@"_placeholderLabel"];
    if (!placeHolderLabel) {
        placeHolderLabel = [[UILabel alloc] init];
        placeHolderLabel.numberOfLines = 0;
        [self addSubview:placeHolderLabel];
        [self setValue:placeHolderLabel forKey:@"_placeholderLabel"];
    }
    
    return placeHolderLabel;
}


@end
