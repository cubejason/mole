//
//  MainTabBarController.m
//  MoleFinance
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "MainTabBarController.h"
#import "ListController.h"
#import "OptionalStockController.h"
#import "InvestOpinionController.h"
#import "image.h"
@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    self.title=@"我的自选";
    //先往tabbar添加controller
    [self setupTabBarController];
    //再处理tabbar的item
    [self setupView];
    
}

-(void)setupTabBarController{
    NSMutableArray*arr=[[NSMutableArray alloc]init];
 NSArray*name=@[@"OptionalStockController",@"InvestOpinionController",@"ListController"];
    
    for (int i=0; i<3; i++) {
        Class class=NSClassFromString(name[i]) ;
        UIViewController *vc=[[class alloc]init];
        [arr addObject:vc];
    }
    self.viewControllers=arr;
    
}
//user_detail_header_background   investment_left_select.9  shadow
-(void)setupView{
    
    //tabbar的颜色
    self.tabBar.barTintColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bar_background.9"]];
 
 NSArray*picture=@[@"bottom_bar_preference_stock",@"bottom_bar_investment_discovery",@"bottom_bar_discovery"];
    NSArray *title=@[@"自选股",@"投资观点",@"榜单发现"];
    
    for (int i=0; i<3; i++) {
        UITabBarItem *item=self.tabBar.items[i];
        UIImage *Ima=[[UIImage imageNamed:picture[i]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        CGSize size=CGSizeMake(30, 30);
        //调用类方法控制图片大小
        Ima=[image reSizeImage:Ima toSize:size];

        item=[item initWithTitle:title[i] image:Ima selectedImage:nil];
        self.tabBar.selectedImageTintColor = [UIColor whiteColor];
        
        //[item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        
        [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateSelected];
    
    }
    
    
}
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    switch (tabBarController.selectedIndex) {
        case 0:
            self.title=@"我的自选";
            break;
        case 1:
            self.title=@"投资观点";
            break;
        case 2:
            self.title=@"榜单发现";
            break;
        default:
            break;
    }
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
