//
//  SearchController.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/8.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "SearchController.h"
#import "StockDetaileController.h"
#import "getMyStock.h"
#import "MBProgressHUDManager.h"
@interface SearchController ()
{
    UISearchBar *seaBar;
    UIView *view;
    UILabel *_name;
    MBProgressHUDManager *manage;
}

@end

@implementation SearchController

- (void)viewDidLoad {
    //添加SearchBar
    [self setupSearchBar];
}
//添加SearchBar
-(void)setupSearchBar{
    view=[[UIView alloc]init];
    view.frame=CGRM(0,0,WIDTH, 44);
    view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"top_bar_background.9"]];
    view.alpha=1;
    [self.navigationController.navigationBar addSubview:view];
    
    seaBar=[[UISearchBar alloc]initWithFrame:CGRM(5, 5, WIDTH-70, 34)];
    seaBar.delegate=self;
    [view addSubview:seaBar];
    seaBar.placeholder=@"请输入股票代码";
    
    UIButton *cancel=[UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame=CGRM(WIDTH-55, 5, 50, 34);
    [cancel setTitle:@"消除" forState:UIControlStateNormal];
    [cancel setTintColor:[UIColor whiteColor]];
    [cancel addTarget:self action:@selector(cancel_touch:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:cancel];
}
-(void)viewDidAppear:(BOOL)animated{
    //开始编辑
    [seaBar becomeFirstResponder];
}
-(void)viewWillDisappear:(BOOL)animated{
    [view removeFromSuperview];
}
-(void)cancel_touch:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];

}
#pragma mark------------UISearchBar相关方法------------
- (BOOL) searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = NO;
    return YES;
}

- (BOOL) searchBarShouldEndEditing:(UISearchBar *)searchBar
{
   
    searchBar.showsCancelButton = NO;
    return YES;
}

//点击消除键
//-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
     //停止编辑
    [searchBar resignFirstResponder];

    //NSString *str=@"sz002230";
    NSString *str=seaBar.text;
    getMyStock *sto=[[getMyStock alloc]init];
    
    StockDetaileController *det=[[StockDetaileController alloc]init];
    //异步加载的意义就是这句代码还没有执行完，就往下执行下一段代码
    sto.seaSto=^(NSArray*arr){
        
       det.model= arr[0];
        if (![det.model.name isEqualToString:@""]) {
           [self.navigationController pushViewController:det animated:YES];
        }else{
            _name=[[UILabel alloc]init];
            [self.view addSubview:_name];
            _name.frame=CGRM(50,200,WIDTH-100,80);
            _name.font=[UIFont systemFontOfSize:20];
            _name.textColor=[UIColor blackColor];
            _name.textAlignment=NSTextAlignmentCenter;
            _name.numberOfLines=0;
            _name.text=@"输入的股票代码有误，请重新输入";
            [self performSelector:@selector(error_touch) withObject:self afterDelay:3];
            [manage hide];
        }
    };
    manage=[[MBProgressHUDManager alloc]initWithView:self.view];
    [manage showMessage:@"正在加载"];
    [sto searchStockData:str];
    
}
-(void)error_touch{
    [_name removeFromSuperview];
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
