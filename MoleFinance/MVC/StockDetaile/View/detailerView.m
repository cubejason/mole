//
//  detailerView.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "detailerView.h"
static NSInteger pading=60;
@implementation detailerView
{
        UILabel *cur;
        UILabel *step;
        UILabel *per;
        float growth;
        float growthPercent;
        StockModel*_model;
}


-(instancetype)initWith:(StockModel*)model{
    self=[super init];
    if (self) {
        _model=model;
        [self setTopView];
        [self setMiddleView];
    }
    return self;
}
//视图最上面的那部分
-(void)setTopView{
    UIView *TopView=[[UIView alloc]initWithFrame:CGRM(0, 0, WIDTH, 40)];
    TopView.backgroundColor=Color(214, 214, 214, 1);
    [self addSubview:TopView];
    cur=[[UILabel alloc]initWithFrame:CGRM(10, 0,pading, 40)];
    [TopView addSubview:cur];
    cur.font=[UIFont systemFontOfSize:18];
    step=[[UILabel alloc]initWithFrame:CGRM(pading+10, 5, 60, 15)];
    [TopView addSubview:step];
    step.font=[UIFont systemFontOfSize:12];
    per=[[UILabel alloc]initWithFrame:CGRM(pading+10, 5+15,60, 15)];
    [TopView addSubview:per];
    per.font=[UIFont systemFontOfSize:12];
    //自选部分
    UIButton *btnOptional=[UIButton buttonWithType:UIButtonTypeCustom];
    [btnOptional setBackgroundImage:[UIImage imageNamed:@"border_button.9"] forState:UIControlStateNormal];
    [btnOptional addTarget:self action:@selector(btnOptional_touch) forControlEvents:UIControlEventTouchUpInside];
    btnOptional.frame=CGRM(WIDTH-80, 5, 70, 30);
    UIImageView *iv=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add_stock_flag"]];
    iv.frame=CGRM(5, 5,20,20);
    [btnOptional addSubview:iv];
    UILabel *lab=[[UILabel alloc]initWithFrame:CGRM(30,0, 40,30)];
    lab.text=@"自选";
    lab.font=[UIFont systemFontOfSize:16 weight:1];
    lab.textColor=[UIColor blackColor];
    [btnOptional addSubview:lab];
    [TopView addSubview:btnOptional];
    
    //颜色
    growth=[_model.currentPrice floatValue]-[_model.closingPrice floatValue];
    growthPercent=growth/[_model.closingPrice floatValue]*100;
    if (growth ==0) {
        cur.textColor=[UIColor blackColor];
        step.textColor=[UIColor blackColor];
        per.textColor=[UIColor blackColor];
        [self fillLable];
    }
    if (growth>0) {
        cur.textColor=Color(210, 30, 6, 1);
        step.textColor=Color(210, 30, 6, 1);
        per.textColor=Color(210, 30, 6, 1);
        cur.text=[NSString stringWithFormat:@"%.2f",[_model. currentPrice floatValue] ];
        per.text=[NSString stringWithFormat:@"+%.2f%@",growthPercent,@"%"];
        step.text=[NSString stringWithFormat:@"+%.2f",growth ];
        
    }
    if (growth <0) {
        cur.textColor=Color(17, 139, 39, 1);
        step.textColor=Color(17, 139, 39, 1);
        per.textColor=Color(17, 139, 39, 1);
        [self fillLable];
    }
}
-(void)fillLable{
    cur.text=[NSString stringWithFormat:@"%.2f",[_model.currentPrice floatValue]];
    per.text=[NSString stringWithFormat:@"%.2f%@",growthPercent ,@"%"];
    step.text=[NSString stringWithFormat:@"%.2f",growth];
    
}
-(void)btnOptional_touch{
    //NSLog(@"自选按钮");
    //从本地取出自选股的数据
    NSMutableArray *myStock=[NSMutableArray arrayWithArray:(NSArray *)[Commond getUserDefaults:@"myStock"]];
    BOOL exit=[myStock containsObject:_model.code];
    if (!exit) {
        [myStock insertObject:_model.code atIndex:0];
        //[myStock addObject:_model.code];
        [Commond setUserDefaults:myStock forKey:@"myStock"];
        NSLog(@"股票成功加入自选股");
    }
    
}
//中间部分View
-(void)setMiddleView{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRM(0,40+5, WIDTH, 60);
    [self addSubview:view];
    UILabel *open=[[UILabel alloc]init];
    open.frame=CGRM(10, 0, WIDTH/2.0-10, 30);
    open.textColor=[UIColor grayColor];
    open.font=[UIFont systemFontOfSize:16];
    open.text=[NSString stringWithFormat:@"今开：%@",_model.openningPrice];
    [view addSubview:open];
    
    UILabel *close=[[UILabel alloc]init];
    close.frame=CGRM(WIDTH/2.0, 0, WIDTH/2.0, 40);
    close.textColor=[UIColor grayColor];
    close.font=[UIFont systemFontOfSize:16];
    close.text=[NSString stringWithFormat:@"昨收：%@",_model.closingPrice];
    [view addSubview:close];
    
    UILabel *hPrice=[[UILabel alloc]init];
    hPrice.frame=CGRM(10, 30, WIDTH/2.0-10,30);
    hPrice.textColor=[UIColor grayColor];
    hPrice.font=[UIFont systemFontOfSize:16];
    hPrice.text=[NSString stringWithFormat:@"最高：%@",_model.hPrice];
    [view addSubview:hPrice];
    
    UILabel *lPrice=[[UILabel alloc]init];
    lPrice.frame=CGRM(WIDTH/2.0,30, WIDTH/2.0,30);
    lPrice.textColor=[UIColor grayColor];
    lPrice.font=[UIFont systemFontOfSize:16];
    lPrice.text=[NSString stringWithFormat:@"最低：%@",_model.lPrice];
    [view addSubview:lPrice];
    
}

@end
