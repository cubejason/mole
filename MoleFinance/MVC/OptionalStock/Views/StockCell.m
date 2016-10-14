//
//  StockCell.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "StockCell.h"

@implementation StockCell
{
    float growth;
    float growthPercent;
}
 -(void)setModel:(StockModel *)model{
     [self setCellFrame];
    _name.text=model.name;
    _number.text=model.code;     
    
     //颜色
      growth=[model.currentPrice floatValue]-[model.closingPrice floatValue];
      growthPercent=growth/[model.closingPrice floatValue]*100;
     if (growth==0) {
         _percent.textColor=[UIColor blackColor];
         _step.textColor=[UIColor blackColor];
         [self fillLable:model];
     }
     if (growth>0) {
         _percent.textColor=Color(210, 30, 6, 1);
         _step.textColor=Color(210, 30, 6, 1);
         _curPrice.text=[NSString stringWithFormat:@"%.2f",[model.currentPrice floatValue]];
         _percent.text=[NSString stringWithFormat:@"+%.2f%@",growthPercent,@"%"];
         _step.text=[NSString stringWithFormat:@"+%.2f",growth];
         
     }
     if (growth<0) {
         _percent.textColor=Color(17, 139, 39, 1);
         _step.textColor=Color(17, 139, 39, 1);
         [self fillLable:model];
     }

}
-(void)fillLable:(StockModel*)model{
    _curPrice.text=[NSString stringWithFormat:@"%.2f",[model.currentPrice floatValue]];
    _percent.text=[NSString stringWithFormat:@"%.2f%@",growthPercent,@"%"];
    _step.text=[NSString stringWithFormat:@"%.2f",growth];
    
}
-(void)setCellFrame {
    _name=[[UILabel alloc]init];
    [self addSubview:_name];
    _name.frame=CGRM(0, 10, WIDTH/4, 20);
    _name.font=[UIFont systemFontOfSize:14];
    _name.textColor=[UIColor blackColor];
    _name.textAlignment=NSTextAlignmentCenter;
    
    _number=[[UILabel alloc]init];
    [self addSubview:_number];
    _number.frame=CGRM(0, 30, WIDTH/4, 20);
    _number.font=[UIFont systemFontOfSize:14];
    _number.textColor=[UIColor blackColor];
    _number.textAlignment=NSTextAlignmentCenter;
    
    _curPrice=[[UILabel alloc]init];
    [self addSubview:_curPrice];
    _curPrice.frame=CGRM(WIDTH/4, 15, WIDTH/4, 30);
    _curPrice.font=[UIFont systemFontOfSize:18];
    _curPrice.textColor=[UIColor blackColor];
    _curPrice.textAlignment=NSTextAlignmentCenter;
    
    _percent=[[UILabel alloc]init];
    [self addSubview:_percent];
    _percent.frame=CGRM(WIDTH/4*2, 15, WIDTH/4, 30);
    _percent.font=[UIFont systemFontOfSize:18];
    _percent.textAlignment=NSTextAlignmentCenter;
    
    _step=[[UILabel alloc]init];
    [self addSubview:_step];
    _step.frame=CGRM(WIDTH/4*3, 15, WIDTH/4-20, 30);
    _step.font=[UIFont systemFontOfSize:18];
    _step.textAlignment=NSTextAlignmentCenter;
    
}

@end
