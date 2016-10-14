//
//  StockModel.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "StockModel.h"

@implementation StockModel
//什么条件下不能用类方法
+(NSArray*)setStockModel:(NSData*)data{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    //NSLog(@"%@",dic);
    NSDictionary *dic1=dic[@"retData"];
    NSArray *arr=dic1[@"stockinfo"];
    NSMutableArray *mArr=[[NSMutableArray alloc]init];
    for (NSDictionary*dict in arr) {
        StockModel *model=[[StockModel alloc]init];
        [model setValuesForKeysWithDictionary:dict];
        //NSLog(@"%@",model.name);
        [mArr addObject:model];
    }
    return mArr;
}
+(NSDictionary*)setMarketDictonary:(NSData *)data{
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
   NSDictionary *dic1=dic[@"retData"];
    NSDictionary *dic2=dic1[@"market"];
    return dic2;
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
