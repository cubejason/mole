//
//  InvestData.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^importantNews) (id);
typedef void(^live) (id);
@interface InvestData : NSObject
@property (nonatomic ,copy) importantNews news;
@property (nonatomic,copy) live live;
-(void)getData:(NSString *)str;
-(void)getLiveData:(NSString *)str;
@end
