//
//  HZErrorViewController.m
//  URLManager
//
//  Created by xzh on 16/3/26.
//  Copyright © 2016年 GeniusBrother. All rights reserved.
//

#import "HZErrorViewController.h"

@interface HZErrorViewController ()

@property(nonatomic, weak) UILabel *errorLabel;

@end

@implementation HZErrorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    UILabel *errorLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    errorLabel.text = self.errorInfo;
    errorLabel.textColor = [UIColor blackColor];
    errorLabel.numberOfLines = 0;
    errorLabel.font = [UIFont systemFontOfSize:18];
    errorLabel.backgroundColor = [UIColor redColor];
    CGSize size = [errorLabel sizeThatFits:CGSizeMake((screenWidth-2*15), 0)];
    errorLabel.frame = CGRectMake(0, 0, size.width, size.height);
    errorLabel.center = CGPointMake(screenWidth/2, screenHeight/2);
    [self.view addSubview:errorLabel];
    self.errorLabel = errorLabel;
    
    
    
}


@end
