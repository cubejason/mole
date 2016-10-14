//
//  OptionalStockController.m
//  MoleFinance
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//http://apis.baidu.com/apistore/stockservice/stock?stockid=sz002230&list=1

#import "OptionalStockController.h"
#import "StockModel.h"
#import "StockCell.h"
#import "tableHeaderView.h"
#import "StockDetaileController.h"
#import "SearchController.h"
#import "getMyStock.h"
#import "Commond.h"
#import "EditController.h"
#import "MBProgressHUDManager.h"
static NSString *cellID=@"stock";
@interface OptionalStockController ()
{
    UIButton *but;
    NSDictionary *StockDic;
    NSArray *myStock;
    UITableView *tab;
    NSTimer *timer;
    BOOL mb;
    MBProgressHUDManager *manager;
}

@end

@implementation OptionalStockController

- (void)viewDidLoad {
    mb=YES;
    [self setupNavigationBarIcon];
     timer=[NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(myStocks) userInfo:nil repeats:YES];
    //[self myStocks];   //获得数据
    [self setTableView]; //描绘界面，填充数据
    
}

#pragma mark------加入tableview------
-(void)setTableView{
    tab=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:tab];

    tab.delegate=self;
    tab.dataSource=self;
    
   
//    tableHeaderView *view=[[tableHeaderView alloc]initWithDic:StockDic];
//    view.frame=CGRM(0, 0, 121*5, 80);
//    tab.tableHeaderView=view;
}
//tableView的相关函数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _StockArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc]init];
    view.frame=CGRM(0,0,WIDTH,30);
    UIView *v=[[UIView alloc]initWithFrame:view.frame];
    [view addSubview:v];
    v.backgroundColor=[UIColor colorWithRed:214/225.f green:214/225.f blue:214/225.f alpha:1];
    v.alpha=1;
    
    UILabel *name=[[UILabel alloc]init];
    name.frame=CGRM(0,0,WIDTH/4.0,30);
    name.text=@"股票名称";
    name.font=[UIFont systemFontOfSize:12];
    name.textColor=[UIColor grayColor];
    name.textAlignment=NSTextAlignmentCenter;
    [view addSubview:name];
    
    UILabel *curPrice=[[UILabel alloc]init];
    curPrice.frame=CGRM(WIDTH/4.0*1,0,WIDTH/4.0,30);
    curPrice.text=@"当前价";
    curPrice.font=[UIFont systemFontOfSize:12];
    curPrice.textColor=[UIColor grayColor];
    curPrice.textAlignment=NSTextAlignmentCenter;
    [view addSubview:curPrice];
    
    UILabel *percent=[[UILabel alloc]init];
    percent.frame=CGRM(WIDTH/4.0*2,0,WIDTH/4.0,30);
    percent.text=@"涨跌额";
    percent.font=[UIFont systemFontOfSize:12];
    percent.textColor=[UIColor grayColor];
    percent.textAlignment=NSTextAlignmentCenter;
    [view addSubview:percent];
    
    UILabel *step=[[UILabel alloc]init];
    step.frame=CGRM(WIDTH/4.0*3,0,WIDTH/4.0,30);
    step.text=@"涨跌幅";
    step.font=[UIFont systemFontOfSize:12];
    step.textColor=[UIColor grayColor];
    step.textAlignment=NSTextAlignmentCenter;
    [view addSubview:step];
    
    return view;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    StockCell *cell=[tableView dequeueReusableCellWithIdentifier:cellID];
    cell=[[StockCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    //移动cell需要
    cell.showsReorderControl =YES;
    cell.model=_StockArr[indexPath.row];

    return cell;
}

#pragma mark------tableView关于删除的相关方法-------
//可以编辑tab.editing=YES;
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"删除";
}
//点击删除时执行的方法
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete){
    //取出数据
    NSMutableArray *collection=[NSMutableArray arrayWithArray:(NSArray*)[Commond getUserDefaults:@"myStock"]];
    //删除数据
    [collection removeObjectAtIndex:indexPath.row];
    //重置本地数据
    [Commond setUserDefaults:collection forKey:@"myStock"];
    //必须从数组删除数据
    [_StockArr removeObjectAtIndex:indexPath.row];
    //删除cell
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    }
}

//可以返回三种类型（添加cell，删除cell，不可以编辑）
- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    //添加cell
    //return UITableViewCellEditingStyleInsert;
    //可以删除cell
    return UITableViewCellEditingStyleDelete;
    //可以删除多个cell
    //return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}
#pragma mark--------获得数据---------
//自选股票
-(void)myStocks{

    //取出存储在本地文件中得数据
    myStock=(NSArray*)[Commond getUserDefaults:@"myStock"];
    if (myStock.count==0) {
        //NSLog(@"本地存储成功了");
         NSArray *arr=[NSMutableArray arrayWithObjects:@"sz002230",@"sz002725", nil];
        [Commond setUserDefaults:arr forKey:@"myStock"];
        myStock=(NSArray*)[Commond getUserDefaults:@"myStock"];
    }
    
    if (mb) {
        manager = [[MBProgressHUDManager alloc] initWithView:self.view];
        [manager showSuccessWithMessage:@"正在加载"];
    }
    mb=NO;
    getMyStock *sto=[[getMyStock alloc]init];
    sto.mystock=^(NSData *data){
        _StockArr=[NSMutableArray arrayWithArray:[StockModel setStockModel:data]];
        //print(_StockArr)
        StockDic=[StockModel setMarketDictonary:data];
        /*
         
        //创建tableHeaderView
         
        */
        tableHeaderView *view=[[tableHeaderView alloc]initWithDic:StockDic];
        view.frame=CGRM(0, 0, 121*5, 80);
        tab.tableHeaderView=view;
        
        [tab reloadData];
        [manager hide];
    };

    [sto getOptionalStockData:myStock];
    
}


#pragma make----设置navigationBar上的图标------
//设置navigationBar上的图标
-(void)setupNavigationBarIcon{
    //进入个人主页的按钮
    UIImage *ima=[[UIImage imageNamed:@"main_page_user_portrait_empty"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *MeIma=[image reSizeImage:ima toSize:CGSizeMake(30, 30)];
    UIBarButtonItem *ButMe=[[UIBarButtonItem alloc]initWithImage:MeIma style:UIBarButtonItemStylePlain target:self action:@selector(touch_ButMe)];
    self.parentViewController.navigationItem.leftBarButtonItem=ButMe;
    //搜索按钮
    UIImage *SeaIma=[image reSizeImage:[UIImage imageNamed:@"umeng_socialize_search_icon"] toSize:CGSizeMake(20, 20)];
    UIBarButtonItem *ButSearch=[[UIBarButtonItem alloc]initWithImage:SeaIma style:UIBarButtonItemStylePlain target:self action:@selector(touch_ButSearch)];
    self.parentViewController.navigationItem.rightBarButtonItem=ButSearch;
   //编辑按钮在网页出现后添加，在离开网页时去除
    
}

//编辑按钮
-(void)viewWillDisappear:(BOOL)animated{
     [but removeFromSuperview];
    //
    [timer invalidate];
    timer =nil;
}
-(void)viewWillAppear:(BOOL)animated{
    but=[UIButton buttonWithType:UIButtonTypeCustom];
    [but addTarget:self action:@selector(touch_But) forControlEvents:UIControlEventTouchDown];
    [but setImage:[UIImage imageNamed:@"edit_normal"] forState:UIControlStateNormal];
    but.frame=CGRectMake(WIDTH-90,11, 20, 20);
    [self.navigationController.navigationBar addSubview:but];
}

#pragma mark -------navigationBar上的按钮所对应的方法-------
//进入个人主页的方法
-(void)touch_ButMe{
    NSLog(@"ButMe is user");
}
//搜索股票的方法
-(void)touch_ButSearch{
    SearchController *sea=[[SearchController alloc]init];
    //[self presentViewController:sea animated:YES completion:nil];
    [self.parentViewController.navigationController pushViewController:sea animated:YES];
    
}
//编辑按钮的方法
-(void)touch_But{
    EditController *edit=[[EditController alloc]init];
    edit.collection=[NSMutableArray arrayWithArray:_StockArr];
    [self.parentViewController.navigationController pushViewController:edit animated:YES];
}


#pragma mark----------------点击cell----------------------
//点击cell
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StockDetaileController *detaile=[[StockDetaileController alloc]init];
    detaile.model=_StockArr[indexPath.row];
    [self.parentViewController.navigationController pushViewController:detaile animated:YES];
    
}
//每次出现
-(void)viewDidAppear:(BOOL)animated{
    if (tab==nil) {
        NSLog(@"tab不存在");
    }else{
        NSLog(@"刷新tab");
        [self myStocks];
    }
}
#pragma mark--------本地通知-------------
//-(void)addLocalNotification{
//    
//    NSString * fileName = [[NSBundle mainBundle] pathForResource:@"SettingStatus" ofType:@"plist"];
//    NSDictionary * dic = [NSDictionary dictionaryWithContentsOfFile:fileName];
//    //NSLog(@"#########%@",dic);
//    NSDate * date = dic[@"AlarmTime"];
//    BOOL flag = NO;
//    NSArray * arrKeys = dic.allKeys;
//    if ([arrKeys containsObject:@"weekDays"]) {
//        flag = YES;
//    }
//    
//    
//    if (flag == NO || (flag == YES&& [dic[@"weekDays"] isEqual:@"unrepeat"])) {
//        
//        UILocalNotification *notification=[[UILocalNotification alloc]init];
//        //设置调用时间
//        notification.fireDate=date;//通知触发的时间
//        notification.repeatInterval=1;//通知重复次数
//        //notification.repeatInterval=  NSCalendarUnitWeekOfYear;//当前日历，使用前最好设置时区等信息以便能够自动同步时间
//        
//        //设置通知属性
//        notification.alertBody=@"起床了，我要放大招了！"; //通知主体
//        //notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
//        notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
//        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
//        notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
//        //notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
//        
//        //设置用户信息
//        notification.userInfo=@{@"id":@10,@"user":@"angelababy"};//绑定到通知上的其他附加信息
//        
//        //调用通知
//        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//    }
//    
//    //    ********************************************************************************
//    else if(flag == YES &&![dic[@"weekDays"] isEqual:@"unrepeat"] ){
//        
//        NSInteger temp = [self weekDayStr:date];
//        
//        NSArray * arr = dic[@"weekDays"];
//        for (int i = 0; i < arr.count; i ++) {
//            NSDate * dateNew = [NSDate dateWithTimeInterval:(( [arr[i] integerValue] + 7 - temp) * 24 * 60 * 60) sinceDate:date];
//            
//            //NSLog(@"datenew ===== %@, iiiii====%d",dateNew,i);
//            UILocalNotification *notification=[[UILocalNotification alloc]init];
//            //设置调用时间
//            notification.fireDate=dateNew;//通知触发的时间
//            // notification.repeatInterval=1;//通知重复次数
//            notification.repeatInterval=  NSCalendarUnitWeekOfYear;//当前日历，使用前最好设置时区等信息以便能够自动同步时间
//            
//            //设置通知属性
//            notification.alertBody=@"起床了，我要放大招了！"; //通知主体
//            //notification.applicationIconBadgeNumber=1;//应用程序图标右上角显示的消息数
//            notification.alertAction=@"打开应用"; //待机界面的滑动动作提示
//        notification.alertLaunchImage=@"Default";//通过点击通知打开应用时的启动图片,这里使用程序启动图片
//            notification.soundName=UILocalNotificationDefaultSoundName;//收到通知时播放的声音，默认消息声音
//            //notification.soundName=@"msg.caf";//通知声音（需要真机才能听到声音）
//            
//            //设置用户信息
//            notification.userInfo=@{@"id":arr[i],@"user":@"angelababy"};//绑定到通知上的其他附加信息
//            
//            //调用通知
//            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
//            
//        }
//    }
//    
//    //NSLog(@"%@",[UIApplication sharedApplication].scheduledLocalNotifications);
//    
//}
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
