//
//  lines.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/10.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface lines : UIView
@property (nonatomic,assign) CGPoint startPoint; // 线条起点
@property (nonatomic,assign) CGPoint endPoint; // 线条终点
@property (nonatomic,retain) NSArray *points; // 多点连线数组,K线和均线都是存到这个数组
@property (nonatomic,retain) UIColor *color; // 线条颜色
@property (nonatomic,assign) CGFloat lineWidth; // 线条宽度
@property (nonatomic,assign) BOOL isK;// 是否是实体K线 默认是连接线
@property (nonatomic,assign) BOOL isVol;// 是否是画成交量的实体



@end
