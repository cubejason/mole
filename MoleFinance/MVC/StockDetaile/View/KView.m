//
//  KView.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/9.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "KView.h"
#import "lineView.h"
@implementation KView
{
    UIButton *btnTimeShare; //分时图
    UIButton *btnFiveDay;   //五日图
    UIButton *btnDay;
    UIButton *btnWeek;
    UIButton *btnMonth;
    UIButton *btnMinutes;
    lineView *lineview;
    NSString *rep; //K线类型
}

-(instancetype)initWith:(NSString *)str{
    self=[super init];
    if (self) {
        rep=str;
        [self setupView];
    }
    return self;
}
-(void)setupView{
    
    // 分时按钮
    btnTimeShare= [[UIButton alloc] initWithFrame:CGRectMake(0,0,WIDTH/6.0, 30)];
    [btnTimeShare setTitle:@"分时" forState:UIControlStateNormal];
    [btnTimeShare addTarget:self action:@selector(ktimeshareLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnTimeShare];
    [self addSubview:btnTimeShare];
    // 五日按钮
    btnFiveDay = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/6.0,0,WIDTH/6.0, 30)];
    [btnFiveDay setTitle:@"五日" forState:UIControlStateNormal];
    [btnFiveDay addTarget:self action:@selector(kFiveDayLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnFiveDay];
    [self addSubview:btnFiveDay];
    // 日k按钮
    btnDay = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/6.0*2,0,WIDTH/6.0, 30)];
    [btnDay setTitle:@"日K" forState:UIControlStateNormal];
    [btnDay addTarget:self action:@selector(kDayLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnDay];
    [self addSubview:btnDay];
    // 周k按钮
    btnWeek = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/6.0*3,0,WIDTH/6.0, 30)];
    [btnWeek setTitle:@"周K" forState:UIControlStateNormal];
    [btnWeek addTarget:self action:@selector(kWeekLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnWeek];
    [self addSubview:btnWeek];
    // 月k按钮
    btnMonth = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/6.0*4,0,WIDTH/6.0, 30)];
    [btnMonth setTitle:@"月K" forState:UIControlStateNormal];
    [btnMonth addTarget:self action:@selector(kMonthLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnMonth];
    [self addSubview:btnMonth];

    // 分钟按钮
    btnMinutes = [[UIButton alloc] initWithFrame:CGRectMake(WIDTH/6.0*5,0,WIDTH/6.0, 30)];
    [btnMinutes setTitle:@"分钟" forState:UIControlStateNormal];
    [btnMinutes addTarget:self action:@selector(kMinutesLine) forControlEvents:UIControlEventTouchUpInside];
    [self setButtonAttr:btnMinutes];
    [self addSubview:btnMinutes];
    
    self.backgroundColor = Color(200, 200, 200, 1);
    
    // 添加k线图
    lineview = [[lineView alloc] init];
    if (HEIGHT>=650) {
        NSLog(@"屏幕高度是：%f",HEIGHT);
        lineview.frame = CGRM(0, 30+10, WIDTH, 450);
        [self addSubview:lineview];
    }else{
        
        UIScrollView *scr=[[UIScrollView alloc]init];
        scr.frame=CGRM(0, 40,WIDTH,HEIGHT-60);
        scr.contentSize=CGSizeMake(WIDTH,650);
        [self addSubview:scr];
        scr.scrollEnabled=YES;
        lineview.frame = CGRM(0,0, WIDTH,650);
        [scr addSubview:lineview];
        NSLog(@"屏幕高度是");
    }
    
    
    //--------开始进入时的K线图--------
    lineview.req_type = @"d";
    lineview.req_freq = rep;
    lineview.kLineWidth = 5;
    lineview.kLinePadding = 0.5;
    [lineview start];                    // k线图运行
    [self setButtonAttrWithClick:btnDay];//日K按钮的颜色
}
// 分时
-(void)ktimeshareLine{
    [self setNomalColor];
    [self setButtonAttrWithClick:btnTimeShare];
    
}
// 五日
-(void)kFiveDayLine{
    [self setNomalColor];
    [self setButtonAttrWithClick:btnFiveDay];
}
// 日k
-(void)kDayLine{
    [self setNomalColor];
    [self setButtonAttrWithClick:btnDay];
    lineview.req_type = @"d";
    [self kUpdate];
}
// 周k
-(void)kWeekLine{
    [self setNomalColor];
    [self setButtonAttrWithClick:btnWeek];
    lineview.req_type = @"w";
    [self kUpdate];
}
// 月k
-(void)kMonthLine{
    [self setNomalColor];
    [self setButtonAttrWithClick:btnMonth];
    lineview.req_type = @"m";
    [self kUpdate];
}
// 分钟
-(void)kMinutesLine{
    [self setNomalColor];
    [self setButtonAttrWithClick:btnMinutes];
}
//未点击时的颜色
-(void)setButtonAttr:(UIButton*)button{
    button.backgroundColor = Color(140, 140, 140, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
//点击后的颜色
-(void)setButtonAttrWithClick:(UIButton*)button{
    button.backgroundColor =Color(180, 180, 180, 1);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
//把控件都变为未点击时的颜色
-(void)setNomalColor{
    [self setButtonAttr:btnDay];
    [self setButtonAttr:btnWeek];
    [self setButtonAttr:btnMonth];
    [self setButtonAttr:btnFiveDay];
    [self setButtonAttr:btnMinutes];
    [self setButtonAttr:btnTimeShare];
}
//K线图转换
-(void)kUpdate{
    [lineview update];
}

@end
