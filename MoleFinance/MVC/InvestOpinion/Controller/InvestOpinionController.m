//
//  InvestOpinionController.m
//  MoleFinance
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "InvestOpinionController.h"
#import "ImportantNewsController.h"
#import "SelectedController.h"
#import "LiveController.h"
#import "DarkHorse.h"
const CGFloat font=16;
static CGFloat height=30+110;
@interface InvestOpinionController (){
    UIButton *btnNews;
    UIButton *btnMe;
    UIButton *btnLive;
    UIButton *btnBlack;
    NSInteger *account;//控制scroll的偏移量
    UIScrollView *scroll;
    
    ImportantNewsController *news;
    SelectedController *me;
    LiveController *live;
    DarkHorse *dark;
}

@end

@implementation InvestOpinionController

- (void)viewDidLoad {
    account=0;
    [self setupControllerView];
    
    scroll=[[UIScrollView alloc]init];
    scroll.delegate=self;
    scroll.frame=CGRM(0, 30, WIDTH, HEIGHT-height);
    [self.view addSubview:scroll];
    scroll.contentSize=CGSizeMake(WIDTH*4,HEIGHT-height);
    scroll.pagingEnabled=YES;
    
    [self btnNews_touch];
}
-(void)setupControllerView{
    UIView *view=[[UIView alloc]init];
    view.frame=CGRM(0,0, WIDTH, 30);
    [self.view addSubview:view];
    
    //四个button
    btnNews=[Commond createButtonWithTitle:@"要闻"  target:self action:@selector(btnNews_touch) fontSize:font];
    btnNews.frame=CGRM(0, 0, WIDTH/4.0, 30);
    [view addSubview:btnNews];
    
    btnMe=[Commond createButtonWithTitle:@"大盘"  target:self action:@selector(btnMe_touch) fontSize:font];
    btnMe.frame=CGRM(WIDTH/4.0, 0, WIDTH/4.0, 30);
    [view addSubview:btnMe];
    
    btnLive=[Commond createButtonWithTitle:@"直播"  target:self action:@selector(btnLive_touch) fontSize:font];
    btnLive.frame=CGRM(WIDTH/4.0*2, 0, WIDTH/4.0, 30);
    [view addSubview:btnLive];
    
    btnBlack=[Commond createButtonWithTitle:@"黑马"  target:self action:@selector(btnBlack_touch) fontSize:font];
    btnBlack.frame=CGRM(WIDTH/4.0*3, 0, WIDTH/4.0, 30);
    [view addSubview:btnBlack];
    
}
#pragma mark------button上的所有方法---------
//要闻方法
-(void)btnNews_touch{
    [self setNomalColor];
    [Commond setButtonAttrWithClick:btnNews];
    account=0;
    scroll.contentOffset=CGPointMake(0*WIDTH, 0);
    if (news==nil) {
        news=[[ImportantNewsController alloc]init];
        news.view.frame=CGRM(0, 0, WIDTH, HEIGHT-height);
        [scroll addSubview:news.view];
    }
}
//自选方法
-(void)btnMe_touch{
    [self setNomalColor];
    [Commond setButtonAttrWithClick:btnMe];
    scroll.contentOffset=CGPointMake(1*WIDTH, 0);
    if (me==nil) {
        me=[[SelectedController alloc]init];
        me.view.frame=CGRM(1*WIDTH, 0, WIDTH, HEIGHT-height);
        [scroll addSubview:me.view];
    }
}
//直播
-(void)btnLive_touch{
   [self setNomalColor];
    [Commond setButtonAttrWithClick:btnLive];
    scroll.contentOffset=CGPointMake(2*WIDTH, 0);
    if (live==nil) {
        live=[[LiveController alloc]init];
        live.view.frame=CGRM(2*WIDTH, 0, WIDTH, HEIGHT-height);
        [scroll addSubview:live.view];
    }
}
//黑马
-(void)btnBlack_touch{
    [self setNomalColor];
    [Commond setButtonAttrWithClick:btnBlack];
    scroll.contentOffset=CGPointMake(3*WIDTH, 0);
    if (dark==nil) {
        dark=[[DarkHorse alloc]init];
        dark.view.frame=CGRM(3*WIDTH, 0, WIDTH, HEIGHT-height);
        [scroll addSubview:dark.view];
    }
}
//scroll的协议方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.x==0) {
        [self btnNews_touch];
    }
    if (scrollView.contentOffset.x==WIDTH) {
        [self btnMe_touch];
    }
    if (scrollView.contentOffset.x==WIDTH*2) {
        [self btnLive_touch];
    }
    if (scrollView.contentOffset.x==WIDTH*3) {
        [self btnBlack_touch];
    }
}
//把控件都变为未点击时的颜色
-(void)setNomalColor{
    [Commond setButtonAttr:btnNews];
    [Commond setButtonAttr:btnMe];
    [Commond setButtonAttr:btnLive];
    [Commond setButtonAttr:btnBlack];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
