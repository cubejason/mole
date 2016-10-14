//
//  RootNavigationController.m
//  MoleFinance
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "RootNavigationController.h"
#import "image.h"
@interface RootNavigationController ()

@end

@implementation RootNavigationController

- (void)viewDidLoad {

    //self.navigationBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bar_background.9"]];
     self.navigationBar.tintColor=[UIColor whiteColor];
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    UIImage *ima=[image reSizeImage:[UIImage imageNamed:@"top_bar_background.9"] toSize:CGSizeMake(WIDTH, 44)];
    [self.navigationBar setBackgroundImage:ima forBarMetrics:UIBarMetricsDefault];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
