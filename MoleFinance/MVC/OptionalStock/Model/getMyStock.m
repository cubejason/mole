//
//  getMyStock.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "getMyStock.h"
#import "MBProgressHUDManager.h"

@implementation getMyStock{
  
}
//从网上获取数据
-(void)getOptionalStockData:(NSArray*)arr{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/stockservice/stock";
    NSMutableString *httpArg=[NSMutableString stringWithString:@"list=1"];
    
    for (int i=0; i<arr.count; i++) {
        if (i==0) {
            [httpArg appendFormat:@"&stockid=%@",arr[i]];
        }else{
            [httpArg appendFormat:@",%@",arr[i]];
        }
    }
    
    NSLog(@"自选股的网址：%@",httpArg);
    
    [self request: httpUrl withHttpArg: httpArg];
}
-(void)request: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    
    
//    [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:_waitView];
//    _waitView.labelText = @"加载中";
//    [_waitView show:YES];
    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"b36264b7c4aace93519a45305fcfda92" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                                   //                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   //                                   NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                   //                                   NSLog(@"HttpResponseCode:%ld", responseCode);
                                   //                                   NSLog(@"HttpResponseBody %@",responseString);
                                   self.mystock(data);
                               }
//                               [_waitView removeFromSuperview];
                           }];
}
//seach时会调用
-(void)searchStockData:(NSString*)str{
    NSString *httpUrl = @"http://apis.baidu.com/apistore/stockservice/stock";
    NSString *httpArg=[NSString stringWithFormat:@"stockid=%@&list=1",str];
   [self searchRequest: httpUrl withHttpArg: httpArg];
}
-(void)searchRequest: (NSString*)httpUrl withHttpArg: (NSString*)HttpArg  {
    
    NSString *urlStr = [[NSString alloc]initWithFormat: @"%@?%@", httpUrl, HttpArg];
    //NSLog(@"#########%@",urlStr);
    NSURL *url = [NSURL URLWithString: urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [request addValue: @"b36264b7c4aace93519a45305fcfda92" forHTTPHeaderField: @"apikey"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
            if (error) {
                    NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
//                                  NSString *responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//                                   NSLog(@"HttpResponseBody %@",responseString);
            NSArray *arra=[StockModel setStockModel:data];
            self.seaSto(arra);
                       }
    
                           }];
  
}
@end
