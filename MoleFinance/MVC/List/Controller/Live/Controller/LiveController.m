//
//  LiveController.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "LiveController.h"
#import "InvestData.h"
#import "LiveCell.h"
#import "baseController.h"
static NSString *cellid=@"live";
@interface LiveController ()
{
    NSMutableArray *collection;
    UITableView *tab;
    NSInteger _page;
     CGFloat height;
    
}

@end

@implementation LiveController

- (void)viewDidLoad {
    collection=[[NSMutableArray array]init];
    _page=20;
    //self.view.backgroundColor=[UIColor redColor];
    [self setupTableView];
    //[self getData];
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
    NSString *url=[NSString stringWithFormat:API_LIVE,_page];
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
    [tab registerNib:[UINib nibWithNibName:@"LiveCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellid];
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
    return height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=collection[indexPath.row];
    LiveCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    //[dic[@"digest"] 没有内容，用[dic[@"title"]
    if ([dic[@"digest"] isEqualToString:@""]) {
        cell.title.numberOfLines=0;
        CGSize size = [dic[@"title"] boundingRectWithSize:CGSizeMake(cell.title.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        CGRect rect=cell.title.frame;
        rect.size.height=size.height;
        cell.title.frame = rect;
        cell.title.text=dic[@"title"];
        //print(cell.title.text)
        height=CGRectGetMaxY(cell.time.frame)+5+size.height+8;
    }else{
        //得到一行文字，lable的高度
    CGSize test = [@"高度" boundingRectWithSize:CGSizeMake(cell.title.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    
    CGSize size = [dic[@"digest"] boundingRectWithSize:CGSizeMake(cell.title.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
    //不超过3行
    if (size.height<=test.height*3) {
        
        cell.title.numberOfLines=0;
        //NSLog(@"lable的高度==%f",size.height);
    }else{
        //四行及以上
       cell.title.numberOfLines=4;
        size.height=test.height*4;
    }
    
    CGRect rect=cell.title.frame;
    rect.size.height=size.height;
    cell.title.frame = rect;
    cell.title.text=dic[@"digest"];
    //print(cell.title.text)
    height=CGRectGetMaxY(cell.time.frame)+5+size.height+8;
    }
    //显示时间的Lable相关
    cell.time.text=dic[@"showtime"];
    cell.time.textColor=[UIColor grayColor];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"我可以点击");
    baseController *base=[[baseController alloc]init];
    base.urlString=API_LIVE_CLICK;
    base.tagget=2;
    [self presentViewController:base animated:YES completion:nil];
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
