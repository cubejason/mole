//
//  getMyStock.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StockModel.h"
typedef void(^Searchstock)(NSArray *);
@interface getMyStock : NSObject
@property (nonatomic,copy)void (^mystock)(NSData *);
@property (nonatomic,copy)Searchstock seaSto;
-(void)getOptionalStockData:(NSArray*)arr;
-(void)searchStockData:(NSString*)str;
@end
