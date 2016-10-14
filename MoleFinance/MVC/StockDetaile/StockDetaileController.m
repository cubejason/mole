//
//  StockDetaileController.m
//  MoleFinance
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "StockDetaileController.h"
#import "detailerView.h"
#import "KView.h"
@interface StockDetaileController ()

@end

@implementation StockDetaileController

- (void)viewDidLoad {
    [self setNavegationBar];
    //上面部分
    detailerView *detailer=[[detailerView alloc]initWith:_model];
    detailer.frame=CGRM(0, 0, WIDTH, 105);
    [self.view addSubview:detailer];
    //K线部分
    NSMutableString *mstr=[NSMutableString stringWithString:_model.code];
    NSString *str=[mstr substringWithRange:NSMakeRange(0, 2)];
    NSString *string;
    if ([str isEqualToString:@"sz"]) {
        string=@"SZ";
    }else{
        string=@"SS";
    }
    [mstr deleteCharactersInRange:NSMakeRange(0, 2)];
    NSString *code=[NSString stringWithFormat:@"%@.%@",mstr,string];
    NSLog(@"%@",code);
    KView *kview=[[KView alloc]initWith:code];
    kview.frame=CGRM(0, 105, WIDTH, 500);
    [self.view addSubview:kview];
}
//添加NavegationBar
-(void)setNavegationBar{
    self.title=_model.name;
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:self action:@selector(btn_touch) forControlEvents:UIControlEventTouchUpInside];
    btn.frame=CGRM(0, 0, 60, 30);
    UIImageView *iv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"top_bar_back"]];
    iv.frame=CGRM(0, 0, 20, 30);
    [btn addSubview:iv];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRM(20, 0, 40, 30)];
    lab.text=@"返回";
    lab.font=[UIFont systemFontOfSize:18];
    lab.textColor=[UIColor whiteColor];
    [btn addSubview:lab];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
}
-(void)btn_touch{
    [self.navigationController popToRootViewControllerAnimated:YES];
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
