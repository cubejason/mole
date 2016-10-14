//
//  lineView.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//
// http://ichart.yahoo.com/table.csv?s=399001.SZ&g=w  d,w,m  返回某个股票的天，星期，月等k线数据
//股票代码 规则是：沪股代码末尾加.ss，深股代码末尾加.sz。如浦发银行的代号是：600000.SS


#import "lineView.h"
#import "getData.h"
#import "lines.h"
#import "MBProgressHUDManager.h"
static float padding=20;
static float dataLab=70;
@interface lineView(){
    NSThread *thread;
    UIView *mainboxView; // k线图控件,装着K线图的矩形
    UIView *bottomBoxView; //装着成交量条形图的矩形
    getData *getdata;
//    UIView *movelineone; // 手指按下后显示的两根白色十字线
//    UIView *movelinetwo;
//    UILabel *movelineoneLable;// 手指按下后显示的两条信息
//    UILabel *movelinetwoLable;//手指按下后显示的两条信息
    NSMutableArray *pointArray; // k线所有坐标数组
    CGFloat MADays;  //显示一共几天的K线
    UILabel *MA5; // 5均线显示
    UILabel *MA10; // 10均线
    UILabel *MA20; // 20均线
    UILabel *startDateLab; //k线开始时的时间
    UILabel *endDateLab;    //k线结束时的时间
    UILabel *volMaxValueLab; // 显示成交量最大值
    BOOL isUpdate;//是否可以在日K、周K等进行切换
    BOOL isUpdateFinish;
    NSMutableArray *lineArray ; // k线数组，里面的一个元素就代表一条线 leftTag line kline
    NSMutableArray *lineOldArray ; // k线数组
    UIButton *moreBigBtn;    //放大
    UIButton *moreSmallBtn;   //缩小
    
    MBProgressHUDManager *manage;
    BOOL mb;
}

@end
@implementation lineView
//设置最初的一些参数
-(id)init{
    self = [super init];
    [self initSet];
    return self;
}
-(void)initSet{
    mb=YES;
    self.xWidth =WIDTH-50; // k线图宽度
    self.yHeight = 250; // k线图高度
    self.bottomBoxHeight = 100; // 底部成交量图的高度
    self.kLineWidth = 5;// k线实体的宽度
    self.kLinePadding = 1; // k实体的间隔
    self.endDate = [NSDate date];
    self.req_url = @"http://ichart.yahoo.com/table.csv?s=%@&g=%@";
    //view上所有文字的大小
    self.font = [UIFont systemFontOfSize:10];
//    MADays = 20; //开始时K线
    isUpdate = NO;
    isUpdateFinish = YES;
    lineArray = [[NSMutableArray alloc] init];
    lineOldArray = [[NSMutableArray alloc] init];

}
//进入详细页面就要花K线图框架
-(void)start{
    //画K线图的外部框架
    [self drawBox];
    //另开一个线程画K线图 两个线程同时进行，加快效率
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawLine) object:nil];
    [thread start];
}
#pragma mark 画框框和平均线  先画box，再画line
// 画个k线图的框框
-(void)drawBox{
    if (mainboxView==nil) {
        mainboxView = [[UIView alloc] initWithFrame:CGRectMake(40, 20, self.xWidth, self.yHeight)];
        mainboxView.backgroundColor =[UIColor whiteColor];
        //mainboxView.layer.borderWidth = 0.5;
        mainboxView.userInteractionEnabled = YES;
        [self addSubview:mainboxView];
    }
    
    //放大的控件
    if (moreBigBtn==nil) {
        moreBigBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        moreBigBtn.frame=CGRM(CGRectGetMaxX(mainboxView.frame)-140, CGRectGetMaxY(mainboxView.frame), 40, 40);
        [moreBigBtn setTitle:@"+" forState:UIControlStateNormal];
        [moreBigBtn addTarget:self action:@selector(bigmore_touch) forControlEvents:UIControlEventTouchDown];
        [moreBigBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        moreBigBtn.titleLabel.font=[UIFont systemFontOfSize:30];
        [self addSubview:moreBigBtn];
    }
    //缩小的控件
    if (moreSmallBtn==nil) {
        moreSmallBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        moreSmallBtn.frame=CGRM(CGRectGetMaxX(mainboxView.frame)-80, CGRectGetMaxY(mainboxView.frame), 40, 40);
        [moreSmallBtn setTitle:@"-" forState:UIControlStateNormal];
        [moreSmallBtn addTarget:self action:@selector(smallmore_touch) forControlEvents:UIControlEventTouchUpInside];
        [moreSmallBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        moreSmallBtn.titleLabel.font=[UIFont systemFontOfSize:40];
        [self addSubview:moreSmallBtn];
    }
    
    // 画个成交量的框框
    if (bottomBoxView==nil) {
        bottomBoxView = [[UIView alloc] initWithFrame:CGRectMake(40,CGRectGetMaxY(mainboxView.frame)+40, self.xWidth, self.bottomBoxHeight)];
        bottomBoxView.backgroundColor = [UIColor whiteColor];
        //bottomBoxView.layer.borderWidth = 0.5;
        bottomBoxView.userInteractionEnabled = YES;
        [self addSubview:bottomBoxView];
    }
    
    // 把显示开始结束日期放在成交量的底部左右两侧
    // 显示开始日期控件
    if (startDateLab==nil) {
        startDateLab = [[UILabel alloc] initWithFrame:CGRectMake(bottomBoxView.frame.origin.x,CGRectGetMaxY(bottomBoxView.frame),dataLab, 20)];
        startDateLab.font = self.font;
        startDateLab.text = @"--";
        startDateLab.textColor =Color(26, 26, 26, 1);
        startDateLab.backgroundColor = [UIColor clearColor];
        startDateLab.textAlignment = NSTextAlignmentLeft;
        [self addSubview:startDateLab];
    }
    
    // 显示结束日期控件
    if (endDateLab==nil) {
        endDateLab = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bottomBoxView.frame)-dataLab, startDateLab.frame.origin.y, dataLab,20)];
        endDateLab.font = self.font;
        endDateLab.text = @"--";
        endDateLab.textColor =Color(26, 26, 26, 1);
        endDateLab.backgroundColor = [UIColor clearColor];
        endDateLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:endDateLab];
    }
    
    
    // 显示成交量最大值
    if (volMaxValueLab==nil) {
        volMaxValueLab = [[UILabel alloc] initWithFrame:CGRectMake(0,bottomBoxView.frame.origin.y,40,20)];
        volMaxValueLab.font = self.font;
        volMaxValueLab.text = @"--";
        volMaxValueLab.textColor = Color(26, 26, 26, 1);
        volMaxValueLab.backgroundColor = [UIColor clearColor];
        volMaxValueLab.textAlignment = NSTextAlignmentRight;
        [self addSubview:volMaxValueLab];
    }
    
    
    // 添加平均线值显示
    CGRect mainFrame = mainboxView.frame;
    
    // MA5 均线价格显示控件
    if (MA5==nil) {
        MA5 = [[UILabel alloc] initWithFrame:CGRectMake(mainFrame.origin.x+20,0,60,padding)];
        MA5.backgroundColor = [UIColor clearColor];
        MA5.font = self.font;
        MA5.text = @"MA5:--";
        MA5.textColor = [UIColor blackColor];
        [self addSubview:MA5];
    }
    
    
    // MA10 均线价格显示控件
    if (MA10==nil) {
        MA10 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(MA5.frame) +10, 0,60,padding)];
        MA10.backgroundColor = [UIColor clearColor];
        MA10.font = self.font;
        MA10.text = @"MA10:--";
        MA10.textColor = [UIColor orangeColor];
        [self addSubview:MA10];
    }
    
    
    // MA20 均线价格显示控件
    if (MA20==nil) {
        MA20 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(MA10.frame) +10, 0,60,padding)];
        MA20.backgroundColor = [UIColor clearColor];
        MA20.font = self.font;
        MA20.text = @"MA20:--";
        MA20.textColor = [UIColor greenColor];
        [self addSubview:MA20];
    }
    //isUpdate的作用是初次才需要划线
    if (!isUpdate) {
        // 分割线
        CGFloat padRealValue = mainboxView.frame.size.height / 6;
        for (int i = 0; i<7; i++) {
            CGFloat y = mainboxView.frame.size.height-padRealValue * i;
            lines *line = [[lines alloc] initWithFrame:CGRectMake(0, 0, mainboxView.frame.size.width, mainboxView.frame.size.height)];
            line.color = Color(100, 100, 100, 1);
            line.lineWidth=1;
            line.startPoint = CGPointMake(0, y);
            line.endPoint = CGPointMake(mainboxView.frame.size.width, y);
            [mainboxView addSubview:line];
        }
    }

}
#pragma mark ------------画k线-----------------
//一切关于K线图的改变都要重新调用drawLine
-(void)drawLine{
    if (self.kLineWidth>20) {
        self.kLineWidth+=1;
    }
    if (self.kLineWidth<1) {
        self.kLineWidth+=1;
    }
    self.kCount = self.xWidth / (self.kLineWidth+self.kLinePadding) + 1; // K线中实体的总数

    // 获取网络数据，来源于雅虎财经接口
    getdata = [[getData alloc] init];
    getdata.kCount = self.kCount;            //需要的数据的数量
    getdata.req_type = self.req_type;        //d,w,m
    //------getdata的作用就是获得需要的数据-----
    //菊花

    manage=[[MBProgressHUDManager alloc]initWithView:self];
    [manage showSuccessWithMessage:@"正在下载"];
    //把信息传入到getdata类中，
    getdata = [getdata initWithUrl:[self changeUrl]];
    //得到数据
    __weak typeof(getdata)weakSelf = getdata;
   weakSelf.kdata=^{
        self.data= weakSelf.data;  //K线数组
        //NSLog(@"%@",_data[0]);
        self.category = weakSelf.category; //日期数组
        // 开始画K线图
        [self drawBoxWithKline];
        [manage hide];
    };
    // 清除旧的k线
    if (lineArray.count>0 && isUpdate) {
        for (lines *line in lineArray) {
            [line removeFromSuperview];
        }
    }
    // 结束线程
    [thread cancel];
}
#pragma mark 改变最大值和最小值
//令mainbox分成三等分，只有在中间部分画K线图
-(void)changeMaxAndMinValue{
    CGFloat padValue = (getdata.maxValue - getdata.minValue) / 6;
    getdata.maxValue += padValue;
    getdata.minValue -= padValue;
}
#pragma mark 在框框里画k线
-(void)drawBoxWithKline{
    
    [self changeMaxAndMinValue];
    // 平均线  因为是用循环的方式创建lable,所以创建和赋值在一起
    CGFloat padValue = (getdata.maxValue - getdata.minValue) / 6;
    CGFloat padRealValue = mainboxView.frame.size.height / 6;
    for (int i = 0; i<7; i++) {
        CGFloat y = CGRectGetMaxY(mainboxView.frame)-padRealValue * i;
        // lable
        UILabel *leftTag = [[UILabel alloc] initWithFrame:CGRectMake(0, y-30/2, 38, 30)];
        leftTag.text = [[NSString alloc] initWithFormat:@"%.2f",padValue*i+getdata.minValue];
        leftTag.textColor =[UIColor grayColor];
        leftTag.font = self.font;
        leftTag.textAlignment = NSTextAlignmentRight;
        leftTag.backgroundColor = [UIColor clearColor];
        [self addSubview:leftTag];
        [lineArray addObject:leftTag];
    }
    
    // 开始画连接线
    // x轴从0 到 框框的宽度 mainboxView.frame.size.width 变化  y轴为每个间隔的连线，如，今天的点连接明天的点
    // MA5
    [self drawMAWithIndex:5 andColor:[UIColor blackColor]];
    // MA10
    [self drawMAWithIndex:6 andColor:[UIColor orangeColor]];
    // MA20
    [self drawMAWithIndex:7 andColor:[UIColor greenColor]];
    
    // 开始画连K线
    // x轴从0 到 框框的宽度 mainboxView.frame.size.width 变化  y轴为每个间隔的连线，如，今天的点连接明天的点
    NSArray *ktempArray = [self changeKPointWithData:getdata.data]; // 换算成实际每天收盘价坐标数组
    lines *kline = [[lines alloc] initWithFrame:CGRectMake(0, 0, mainboxView.frame.size.width, mainboxView.frame.size.height)];
    kline.points = ktempArray;
    kline.lineWidth = self.kLineWidth;
    kline.isK = YES;
    [mainboxView addSubview:kline];
    [lineArray addObject:kline]; //为了删除
//
//    // 开始画连成交量
    NSArray *voltempArray = [self changeVolumePointWithData:getdata.data]; // 换算成实际成交量坐标数组
    lines *volline = [[lines alloc] initWithFrame:CGRectMake(0, 0, bottomBoxView.frame.size.width, bottomBoxView.frame.size.height)];
    volline.points = voltempArray;
    volline.lineWidth = self.kLineWidth;
    volline.isK = YES;
    volline.isVol = YES;
    [bottomBoxView addSubview:volline];
    volMaxValueLab.text = [Commond changePrice:getdata.volMaxValue];
    [lineArray addObject:volline];
    
    
    
}
#pragma mark 画各种均线
-(void)drawMAWithIndex:(int)index andColor:(UIColor*)color{
    NSArray *tempArray = [self changePointWithData:getdata.data andMA:index]; // 换算成实际坐标数组
    lines *line = [[lines alloc] initWithFrame:CGRectMake(0, 0, mainboxView.frame.size.width, mainboxView.frame.size.height)];
    line.color = color;
    line.points = tempArray;
    line.isK = NO;
    [mainboxView addSubview:line];
    
    [lineArray addObject:line]; //为了删除
    
}
#pragma mark 把股市数据换算成实际的点坐标数组  MA = 5 为MA5 MA=6 MA10  MA7 = MA20
//根据数据分别得到点的x,y值，然后得到点坐标，用数组保存
-(NSArray*)changePointWithData:(NSArray*)data andMA:(int)MAIndex{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    CGFloat PointStartX = 0.0f; // 起始点坐标
    for (NSArray *item in data) {
        CGFloat currentValue = [[item objectAtIndex:MAIndex] floatValue];// 得到前五天的均价价格
        // 换算成实际的坐标
        CGFloat currentPointY = mainboxView.frame.size.height - ((currentValue - getdata.minValue) / (getdata.maxValue - getdata.minValue) * mainboxView.frame.size.height);
        CGPoint currentPoint =  CGPointMake(PointStartX, currentPointY); // 换算到当前的坐标值
        //需要转化格式
        [tempArray addObject:NSStringFromCGPoint(currentPoint)]; // 把坐标添加进新数组
        PointStartX += self.kLineWidth+self.kLinePadding; // 生成下一个点的x轴
    }
    //print(tempArray);
    return tempArray;
}
#pragma mark 把股市数据换算成实际的点坐标数组
-(NSArray*)changeKPointWithData:(NSArray*)data{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    pointArray = [[NSMutableArray alloc] init];
    CGFloat PointStartX = self.kLineWidth/2; // 起始点坐标
    for (NSArray *item in data) {
        CGFloat heightvalue = [[item objectAtIndex:1] floatValue];// 得到最高价
        CGFloat lowvalue = [[item objectAtIndex:2] floatValue];// 得到最低价
        CGFloat openvalue = [[item objectAtIndex:0] floatValue];// 得到开盘价
        CGFloat closevalue = [[item objectAtIndex:3] floatValue];// 得到收盘价
        CGFloat yHeight = getdata.maxValue - getdata.minValue ; // y的价格高度
        CGFloat yViewHeight = mainboxView.frame.size.height ;// y的实际像素高度
        // 换算成实际的坐标
        CGFloat heightPointY = yViewHeight * (1 - (heightvalue - getdata.minValue) / yHeight);
        CGPoint heightPoint =  CGPointMake(PointStartX, heightPointY); // 最高价换算为实际坐标值
        CGFloat lowPointY = yViewHeight * (1 - (lowvalue - getdata.minValue) / yHeight);;
        CGPoint lowPoint =  CGPointMake(PointStartX, lowPointY); // 最低价换算为实际坐标值
        CGFloat openPointY = yViewHeight * (1 - (openvalue - getdata.minValue) / yHeight);;
        CGPoint openPoint =  CGPointMake(PointStartX, openPointY); // 开盘价换算为实际坐标值
        CGFloat closePointY = yViewHeight * (1 - (closevalue - getdata.minValue) / yHeight);;
        CGPoint closePoint =  CGPointMake(PointStartX, closePointY); // 收盘价换算为实际坐标值
        // 实际坐标组装为数组
        NSArray *currentArray = [[NSArray alloc] initWithObjects:
                                 NSStringFromCGPoint(heightPoint),
                                 NSStringFromCGPoint(lowPoint),
                                 NSStringFromCGPoint(openPoint),
                                 NSStringFromCGPoint(closePoint),
                                 [self.category objectAtIndex:[data indexOfObject:item]], // 保存日期时间
                                 [item objectAtIndex:3], // 收盘价
                                 [item objectAtIndex:5], // MA5
                                 [item objectAtIndex:6], // MA10
                                 [item objectAtIndex:7], // MA20
                                 nil];
        //NSLog(@"#########%@",currentArray);
        /*
         "{283, 176.12060436076004}",
         "{283, 186.69131857035916}",
         "{283, 178.20010158571731}",
         "{283, 180.4528599479745}",
         "2015-09-30",
         "15.35",
         "15.438",
         "15.249",
         "14.998"
         */
        [tempArray addObject:currentArray]; // 把坐标添加进新数组,
        //[pointArray addObject:[NSNumber numberWithFloat:PointStartX]];
        currentArray = Nil;
        PointStartX += self.kLineWidth+self.kLinePadding; // 生成下一个点的x轴
        
        // 在成交量视图左右下方显示开始和结束日期
        if ([data indexOfObject:item]==0) {
            startDateLab.text = [self.category objectAtIndex:[data indexOfObject:item]];
        }
        if ([data indexOfObject:item]==data.count-1) {
            endDateLab.text = [self.category objectAtIndex:[data indexOfObject:item]];
        }
    }
    pointArray = tempArray;
    return tempArray;
}
#pragma mark 把股市数据换算成成交量的实际坐标数组
-(NSArray*)changeVolumePointWithData:(NSArray*)data{
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    CGFloat PointStartX = self.kLineWidth/2; // 起始点坐标
    for (NSArray *item in data) {
        CGFloat volumevalue = [[item objectAtIndex:4] floatValue];// 得到没份成交量
        CGFloat yHeight = getdata.volMaxValue - getdata.volMinValue ; // y的价格高度
        CGFloat yViewHeight = bottomBoxView.frame.size.height ;// y的实际像素高度
        // 换算成实际的坐标
        CGFloat volumePointY = yViewHeight * (1 - (volumevalue - getdata.volMinValue) / yHeight);
        CGPoint volumePoint =  CGPointMake(PointStartX, volumePointY); // 成交量换算为实际坐标值
        CGPoint volumePointStart = CGPointMake(PointStartX, yViewHeight);
        // 把开盘价收盘价放进去好计算实体的颜色
        CGFloat openvalue = [[item objectAtIndex:0] floatValue];// 得到开盘价
        CGFloat closevalue = [[item objectAtIndex:3] floatValue];// 得到收盘价
        CGPoint openPoint =  CGPointMake(PointStartX, closevalue); // 开盘价换算为实际坐标值
        CGPoint closePoint =  CGPointMake(PointStartX, openvalue); // 收盘价换算为实际坐标值
        
        
        // 实际坐标组装为数组
        NSArray *currentArray = [[NSArray alloc] initWithObjects:
                                 NSStringFromCGPoint(volumePointStart),
                                 NSStringFromCGPoint(volumePoint),
                                 NSStringFromCGPoint(openPoint),
                                 NSStringFromCGPoint(closePoint),
                                 nil];
        [tempArray addObject:currentArray]; // 把坐标添加进新数组
        currentArray = Nil;
        PointStartX += self.kLineWidth+self.kLinePadding; // 生成下一个点的x轴
        
    }
    NSLog(@"处理完成");
    
    return tempArray;
}

#pragma mark ------------在不同的K线图之间切换-----------
//在不同种类K线图之间切换
//日K线 周K线切换只需要重新划线就可以了
-(void)update{
    //K线的宽度的范围
    if (self.kLineWidth>20)
        self.kLineWidth = 20;
    if (self.kLineWidth<1)
        self.kLineWidth = 1;
    isUpdate = YES;
    //不知道是做什么的
    if (!thread.isCancelled) {
        [thread cancel];
    }
    self.clearsContextBeforeDrawing = YES;
    //[self drawBox];
    [thread cancel];
    thread = [[NSThread alloc] initWithTarget:self selector:@selector(drawLine) object:nil];
    [thread start];
    
}
#pragma mark ---------放大缩小的方法----
//放大
-(void)bigmore_touch{
    //K线不能大于20
    if (self.kLineWidth<=14) {
        isUpdate=YES;
        self.kLineWidth+=1;
        [self drawLine];
    }
}
//缩小
-(void)smallmore_touch{
    //K线不能小于等于2
    if (self.kLineWidth>2) {
        isUpdate=YES;
        self.kLineWidth-=1;
        [self drawLine];
    }
}

#pragma mark 返回组装好的网址
-(NSString*)changeUrl{
    NSString *url = [[NSString alloc] initWithFormat:self.req_url,self.req_freq,self.req_type];
    NSLog(@"画K线的网址是：%@",url);
    return url;
}
@end
