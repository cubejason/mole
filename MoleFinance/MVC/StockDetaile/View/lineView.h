//
//  lineView.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface lineView : UIView    //lineView就是代表K线图的那部分图片
@property (nonatomic,retain) NSMutableArray *data;     //存K线相关数组
@property (nonatomic,retain) NSMutableArray *category; //存时间的数组
@property (nonatomic,retain) NSString *req_freq;   // 股票代码
@property (nonatomic,retain) NSString *req_type;   // K线类型
@property (nonatomic,retain) NSString *req_url;    //网址
@property (nonatomic,retain) NSDate *startDate; //开始时间
@property (nonatomic,retain) NSDate *endDate;   //结束时间
@property (nonatomic,assign) CGFloat xWidth; // 装着K线图的矩形的宽度
@property (nonatomic,assign) CGFloat yHeight; //装着K线图的矩形的高度
@property (nonatomic,assign) CGFloat bottomBoxHeight; // y轴高度
@property (nonatomic,assign) CGFloat kLineWidth; // k线的宽度 用来计算可存放K线实体的个数，也可以由此计算出起始日期和结束日期的时间段
@property (nonatomic,assign) CGFloat kLinePadding;//K线之间的间隔
@property (nonatomic,assign) int kCount; // k线中实体的总数 通过 xWidth / kLineWidth 计算而来
@property (nonatomic,retain) UIFont *font;//统一的字体

-(void)start;
-(void)update;
@end
