//
//  InvestData.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "InvestData.h"

@implementation InvestData
-(void)getData:(NSString *)str{
    AFHTTPRequestOperationManager *manage=[AFHTTPRequestOperationManager manager];
    [manage GET:str parameters:nil success:^(AFHTTPRequestOperation * op, id response) {
        //print(response);
        self.news(response);
        
    } failure:^(AFHTTPRequestOperation * op, NSError * error) {
        print(error.description)
    }];
}
-(void)getLiveData:(NSString *)str{
    AFHTTPRequestOperationManager *manage=[AFHTTPRequestOperationManager manager];
    [manage GET:str parameters:nil success:^(AFHTTPRequestOperation * op, id response) {
        //print(response);
        self.live(response);
        
    } failure:^(AFHTTPRequestOperation * op, NSError * error) {
        print(error.description)
    }];
}
@end
