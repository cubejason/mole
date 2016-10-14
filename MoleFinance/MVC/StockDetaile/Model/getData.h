//
//  getData.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^Kdata)();  //block一定要带参数
@interface getData : NSObject
@property (nonatomic,copy) Kdata kdata;
@property (nonatomic,retain) NSMutableArray *data;    //包含划线所需数据
@property (nonatomic,retain) NSMutableArray *category; //包含日期数据
@property (nonatomic,assign) CGFloat maxValue;  //收盘价的最大值
@property (nonatomic,assign) CGFloat minValue;  //收盘价的最小值
@property (nonatomic,assign) CGFloat volMaxValue; //成交量的最大值
@property (nonatomic,assign) CGFloat volMinValue; //成交量的最小值
@property (nonatomic,assign) NSInteger kCount;   //K线数量
@property (nonatomic,retain) NSString *req_type;  //d,w,m

-(id)initWithUrl:(NSString*)url;
@end
