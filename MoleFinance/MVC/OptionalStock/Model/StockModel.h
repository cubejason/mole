//
//  StockModel.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StockModel : NSObject
+(NSArray*)setStockModel:(NSData*)data;
+(NSDictionary*)setMarketDictonary:(NSData *)data;
//本来可以更简单
@property (nonatomic,copy)NSString* name;
@property (nonatomic,copy)NSString* code;
@property (nonatomic,copy)NSString* date;
@property (nonatomic,copy)NSString* time;
@property (nonatomic,copy)NSNumber* openningPrice;
@property (nonatomic,copy)NSNumber* closingPrice;
@property (nonatomic,copy)NSNumber* hPrice;
@property (nonatomic,copy)NSNumber* lPrice;
@property (nonatomic,copy)NSNumber* currentPrice;
@property (nonatomic,copy)NSNumber* competitivePrice;
@property (nonatomic,copy)NSNumber* auctionPrice;
@property (nonatomic,copy)NSNumber* totalNumber;
@property (nonatomic,copy)NSNumber* turnover;

@end
/*
 name: "科大讯飞", //股票名称
 code: "sz002230", //股票代码，SZ指在深圳交易的股票
 date: "2014-09-22", //当前显示股票信息的日期
 time: "09:26:11",   //具体时间
 OpenningPrice: 27.34, //今日开盘价
 closingPrice: 27.34,  //昨日收盘价
 currentPrice: 27.34,  //当前价格
 hPrice: 27.34,        //今日最高价
 lPrice: 27.34,       //今日最低价
 competitivePrice: 27.30, //买一报价
 auctionPrice: 27.34,   //卖一报价
 totalNumber: 47800,    //成交的股票数
 turnover: 1306852.00,  //成交额，以元为单位
*/