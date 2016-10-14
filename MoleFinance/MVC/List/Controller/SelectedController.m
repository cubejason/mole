//
//  SelectedController.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "SelectedController.h"
#import "InvestData.h"
#import "SelectionCell.h"
#import "baseController.h"
static NSString *cellid=@"me";
@interface SelectedController (){
    NSMutableArray *collection;
    UITableView *tab;
    //NSInteger _page;
}

@end

@implementation SelectedController

- (void)viewDidLoad {
    collection=[[NSMutableArray array]init];
    _page=20;
    //[self getData];
    [self setupTableView];
}
#pragma mark------得到数据----------
-(void)getData{
    InvestData *inv=[[InvestData alloc]init];
    inv.news=^(NSDictionary* dic){
        if (_page == 20) {   // 下拉刷新状态
            
            // 停止刷新，回到原处(已经得到了数据)
            [tab.header endRefreshing];
            
            // 清空原有的数据
            if (collection.count) {
                [collection removeAllObjects];
            }
            // 将最新数据赋给数据源
            // collection=dic[@"news"]会把可变数组变为不可变
            [collection addObjectsFromArray: dic[@"news"]];
        }else {     // 上拉状态
            
            [tab.footer endRefreshing];
            
            // 将后面的更多数据追加入数据源
            //print(collection)
            NSArray *arr=dic[@"news"];
            [collection addObjectsFromArray:arr];
        }
        [tab reloadData];
    };
    NSString *url=[NSString stringWithFormat:API_ME,_page];
    print(url)
    [inv getData:url];
}

#pragma  mark------所有tableview的协议方法------
-(void)setupTableView{
    tab=[[UITableView alloc]init];
    tab.frame=self.view.frame;
    [self.view addSubview:tab];
    tab.delegate=self;
    tab.dataSource=self;
    [tab registerNib:[UINib nibWithNibName:@"SelectionCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellid];
    //控制navigationBar给页面布局的影响
    self.edgesForExtendedLayout = UIRectEdgeNone;
    //上下拉刷新
    __weak typeof (self) weakSelf=self;
    //得到header
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //下拉刷新时，_page是固定的值
        _page =20;
        [weakSelf getData];
        
    }];
    //建立联系
    tab.header=header;
    //定制刷新样式
    [header setTitle:@"正在刷新" forState:MJRefreshStateIdle];
    //进入就刷新
    [tab.header beginRefreshing] ;
    
    
    //----------  //上拉加载
    MJRefreshAutoNormalFooter *footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page+=20;//上拉刷新时，_page要加20
        [weakSelf getData];
        
    }];
    tab.footer=footer;
    //把上拉刷新和下拉刷新放到tableView的footer和header  不是原来的tableview固有的
    
    //进入就刷新
    footer.automaticallyRefresh=NO;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return collection.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=collection[indexPath.row];
    SelectionCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    cell.title.text=dic[@"title"];
    cell.time.text=dic[@"ordertime"];
    cell.time.textColor=[UIColor grayColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"我可以点击");
    NSDictionary *dic=collection[indexPath.row];
    NSString *UrlString=[NSString stringWithFormat:API_ME_CLICK,dic[@"newsid"],dic[@"newstype"]];
    print(UrlString)
    baseController *base=[[baseController alloc]init];
    base.urlString=UrlString;
    base.tagget=1;
    [self presentViewController:base animated:YES completion:nil];
}
//-(void)viewDidAppear:(BOOL)animated{
//    self.page=20;
//    [self getData];
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
