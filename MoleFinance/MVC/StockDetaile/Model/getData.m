//
//  getData.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "getData.h"

@implementation getData
-(id)init{
    self = [super init];
    if (self){
        self.maxValue =0;
        self.minValue =CGFLOAT_MAX;
        self.volMaxValue = 0;
        self.volMinValue = CGFLOAT_MAX;
    }
    return  self;
}
//----------无论是缓存还是从网络中获得，都需要进一步的加工------
//dayDatas
-(id)initWithUrl:(NSString*)url{

    NSString *urlString=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *nurl = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: nurl cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval: 10];
    [request setHTTPMethod: @"GET"];
    [NSURLConnection sendAsynchronousRequest: request
                                       queue: [NSOperationQueue mainQueue]
                           completionHandler: ^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   NSLog(@"Httperror: %@%ld", error.localizedDescription, error.code);
                               } else {
                        NSString *responseString = [[NSString alloc] initWithData:data encoding: NSUTF8StringEncoding];
                        NSArray *lines=[responseString componentsSeparatedByString:@"\n"];
                        //NSLog(@"%@",arr);
                        [self changeData:lines];
                               }
                               
                           }];

    return self;
}
-(void)changeData:(NSArray*)lines{
    
    NSMutableArray *data =[[NSMutableArray alloc] init];
    NSMutableArray *category =[[NSMutableArray alloc] init];
    NSArray *newArray = lines;
    // 只要前面指定的数据 能够在K线图显示需要的数据
    newArray = [newArray objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:
                                           NSMakeRange(0, self.kCount>=newArray.count?newArray.count:self.kCount)]];
    //newArray是lines的一部分
    
    NSInteger idx;
    int MA5=5,MA10=10,MA20=20;    // 均线统计
    for (idx = newArray.count-1; idx > 0; idx--) {
        NSString *line = [newArray objectAtIndex:idx];
        if([line isEqualToString:@""]){
            continue;
        }
        //arr包含了一天的内容
        NSArray   *arr = [line componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
        // 收盘价的最小值和最大值,为了确定K线图的上下极限
        if ([[arr objectAtIndex:2] floatValue]>self.maxValue) {
            self.maxValue = [[arr objectAtIndex:2] floatValue];
        }
        if ([[arr objectAtIndex:3] floatValue]<self.minValue) {
            self.minValue = [[arr objectAtIndex:3] floatValue];
        }
        //NSLog(@"%f",_minValue);
        // 成交量的最大值最小值，为了确定成交量的上下极限
        if ([[arr objectAtIndex:5] floatValue]>self.volMaxValue) {
            self.volMaxValue = [[arr objectAtIndex:5] floatValue];
        }
        if ([[arr objectAtIndex:5] floatValue]<self.volMinValue) {
            self.volMinValue = [[arr objectAtIndex:5] floatValue];
        }
        NSMutableArray *item =[[NSMutableArray alloc] init];
        [item addObject:[arr objectAtIndex:1]]; // open
        [item addObject:[arr objectAtIndex:2]]; // high
        [item addObject:[arr objectAtIndex:3]]; // low
        [item addObject:[arr objectAtIndex:4]]; // close
        [item addObject:[arr objectAtIndex:5]]; // volume 成交量
        CGFloat idxLocation = [lines indexOfObject:line];
        // MA5
        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA5)]]]; // 前五日收盘价平均值
        // MA10
        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA10)]]]; // 前十日收盘价平均值
        // MA20
        [item addObject:[NSNumber numberWithFloat:[self sumArrayWithData:lines andRange:NSMakeRange(idxLocation, MA20)]]]; // 前二十日收盘价平均值
        // 前面二十个数据不要了，因为只是用来画均线的
        /*
         category收集的是日期
         data的元素是一个包含8个数据的数组
         */
        [category addObject:[arr objectAtIndex:0]]; // date
        [data addObject:item];
    }
 
    self.data = data; // Open,High,Low,Close,Volume,MA5,MA10,MA20
    //NSLog(@"item======%@",data[0]);
    self.category = category; // Date
    self.kdata();
   
}
-(CGFloat)sumArrayWithData:(NSArray*)data andRange:(NSRange)range{
    CGFloat value = 0;
    if (data.count - range.location>range.length) {
        NSArray *newArray = [data objectsAtIndexes:[[NSIndexSet alloc] initWithIndexesInRange:range]];
        for (NSString *item in newArray) {
            NSArray *arr = [item componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@","]];
            value += [[arr objectAtIndex:4] floatValue];
        }
        if (value>0) {
            value = value / newArray.count;
        }
    }
    return value;
}
@end
