//
//  tableHeaderView.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "tableHeaderView.h"

@implementation tableHeaderView{
    UILabel *curPrice;
    UILabel *step;
}

-(instancetype)initWithDic:(NSDictionary*)dic{
    if (self=[super init]) {
  
    UIScrollView *scr=[[UIScrollView alloc]initWithFrame:CGRM(0, 0,WIDTH, 80)];
    scr.contentSize=CGSizeMake(121*5, 80);
    [self addSubview:scr];
    NSArray* arr=@[@"shanghai",@"shenzhen",@"DJI",@"IXIC",@"HSI"];
    for (int i=0; i<5; i++) {
        UIView *view=[self setupView:dic[arr[i]]];
        view.frame=CGRM(121*i, 0, 120, 80);
        view.backgroundColor=[UIColor whiteColor];
        scr.backgroundColor=[UIColor grayColor];
        [scr addSubview:view];
    }
    }
    return self;
   
}
-(UIView*)setupView:(NSDictionary*)dic{
    UIView *view=[[UIView alloc]init];
    //添加控件
    UILabel *name=[[UILabel alloc]init];
    name.frame=CGRM(0, 10, 120, 20);
    name.textAlignment=NSTextAlignmentCenter;
    name.textColor=[UIColor blackColor];
    name.font=[UIFont systemFontOfSize:14];
    [view addSubview:name];
    
    curPrice=[[UILabel alloc]init];
    curPrice.frame=CGRM(0, 10+20, 120, 20);
    curPrice.textAlignment=NSTextAlignmentCenter;
    curPrice.font=[UIFont systemFontOfSize:16];
    [view addSubview:curPrice];
    
    step=[[UILabel alloc]init];
    step.frame=CGRM(0, 10+20+20, 120, 20);
    step.textAlignment=NSTextAlignmentCenter;
    step.font=[UIFont systemFontOfSize:12];
    [view addSubview:step];
    
    //给控件添加数据
    //颜色
    name.text=dic[@"name"];
    if ([dic[@"rate"] floatValue]==0) {
        curPrice.textColor=[UIColor blackColor];
        step.textColor=[UIColor blackColor];
        [self fillLable:dic];
    }
    if ([dic[@"rate"] floatValue]>0) {
        curPrice.textColor=Color(210, 30, 6, 1);
        step.textColor=Color(210, 30, 6, 1);
        curPrice.text=[NSString stringWithFormat:@"%.3f",[dic[@"curdot"] floatValue]];
        NSString *str1=[NSString stringWithFormat:@"+%.2f",[dic[@"curprice"] floatValue]];
        if (str1==NULL) {
            str1=[NSString stringWithFormat:@"+%.2f",[dic[@"growth"] floatValue]];
        }
        NSString *str2=[NSString stringWithFormat:@"+%.2f%@",[dic[@"rate"] floatValue],@"%"];
        step.text=[NSString stringWithFormat:@"%@    %@",str1 ,str2];
        
    }
    if ([dic[@"rate"] floatValue]<0) {
        curPrice.textColor=Color(17, 139, 39, 1);
        step.textColor=Color(17, 139, 39, 1);
        [self fillLable:dic];
    }
    
    return view;
}
-(void)fillLable:(NSDictionary*)dic{

    //填充数据
    curPrice.text=[NSString stringWithFormat:@"%.3f",[dic[@"curdot"] floatValue]];
    NSString *str1=[NSString stringWithFormat:@"%.2f",[dic[@"curprice"] floatValue]];
    if (str1==NULL) {
        str1=[NSString stringWithFormat:@"%.2f",[dic[@"growth"] floatValue]];
    }
    NSString *str2=[NSString stringWithFormat:@"%.2f%@",[dic[@"rate"] floatValue],@"%"];
    step.text=[NSString stringWithFormat:@"%@    %@",str1 ,str2];
    
}
@end
