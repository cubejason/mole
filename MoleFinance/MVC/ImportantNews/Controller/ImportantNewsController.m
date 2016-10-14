//
//  ImportantNewsController.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "ImportantNewsController.h"
#import "InvestData.h"
#import "ImportantNewsCell.h"

#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APAuthV2Info.h"
static NSString *cellid=@"news";

@interface ImportantNewsController (){
    NSMutableArray *collection;
    UITableView *tab;
    NSInteger _page;
}

@end

@implementation ImportantNewsController

- (void)viewDidLoad {
    collection=[[NSMutableArray array]init];
    _page=20;
 //self.view.backgroundColor=[UIColor blueColor];
   // [self getData];
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
    NSString *url=[NSString stringWithFormat:API_NEWS,_page];
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
    [tab registerNib:[UINib nibWithNibName:@"ImportantNewsCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellid];
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
    return 80;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic=collection[indexPath.row];
    ImportantNewsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    cell.title.text=dic[@"simtitle"];
    cell.content.text=dic[@"simdigest"];
    if ([dic[@"simtype_zh" ] isEqual: @""]) {
            cell.num.text=[NSString stringWithFormat:@"%@条评论",dic[@"commentnum"]];
        cell.num.textColor=[UIColor blackColor];
    }else{
        cell.num.text=@"专题";
        cell.num.textColor=[UIColor redColor];
    }
    [cell.ima sd_setImageWithURL:[NSURL URLWithString:dic[@"image"] ]];
    return cell;
}
#pragma mark -
#pragma mark   ==============产生随机订单号==============


- (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand(time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}
#pragma mark -
#pragma mark   ==============点击订单模拟支付行为==============
//
//选中商品调用支付宝极简支付
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    /*
     *点击获取prodcut实例并初始化订单信息
     */
    Product *product = [self.productList objectAtIndex:indexPath.row];
    
    /*
     *商户的唯一的parnter和seller。
     *签约后，支付宝会为每个商户分配一个唯一的 parnter 和 seller。
     */
    
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088811895840552";
    NSString *seller = @"didiyueche@163.com";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKogIOsisP4T4lFmDRcNeuwhjTeoSlKaedqN8Kin/eDJk5ivTuK5piGjG2qTTgnzmL3FZk2V20lHZ7UgGBGhA5q3k3MNKyJfUlCFAHhCDBkXp3JE0+/geM9ML3hcdKBiymiFSZv1GUoaz2AcDXMEb8IjIJKJ8KCmiVu487FcUh7tAgMBAAECgYEAnaRX3Iqw5z8Vn8eoqYvcM6KDcOeItzJdZ5/POPkxz3H6Sqlnt7+/qbuyU/dbgO0ww+h++7W5FRYNi1DJ/MvuwZQwHbeyerSHlNJ4gNg1+o70nLYZ1WOEAsKSCTatcJ5guKWKWN9TFTNH+Gach0YyeQXBzwAvqAGCRjOj/THxMgECQQDVOr0xUrjm18rC9thB70VMwI7ayP3/MSFZd0ugdR/1fc/Xsz27EWwTqDUQ4o1r48QEpSLcMlLOmmE5QnbA0+KRAkEAzEAEKsJQA1hSDNlaDbVZltXXmW5qlwN2elZ1vn/TNCGRiS+37QWWtVEBGMV2qmnMtlR/ny4h7gNiAcpzeZtsnQJAWTuFpTh7DI/N2J04jw80rxP+NGzcboj+7dPQoEujnjaSXjAyazC1S9yeqHxGtpnQlCkPV5rvsGpGuZGo5LVHIQJAd6REDJv37I2uulITGxaQnPc0LG7uRvlDTFQa8nTDzbSgIIDwNwngBuOlRdJdOWNyA5epjh+ixl366duiGqi9TQJATu6HYVuqxOk5gc6jGJ8xGllFQMGd5vLeA5W3mALJU4stvEq6hbWsbEZbEcMc495lfC7UosL/RArbbSsh4jI6gQ==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [self generateTradeNO]; //订单ID（由商家自行制定）
//    order.productName = product.subject; //商品标题
//    order.productDescription = product.body; //商品描述
//    order.amount = [NSString stringWithFormat:@"%.2f",product.price]; //商品价格
    order.productName=@"支付宝";
    order.productDescription=@"未来商业基础设施";
    order.amount= [NSString stringWithFormat:@"%.2f",30.50];
    order.notifyURL =  @"http://121.42.144.10/DDYC/index.jsp"; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"alisdkdemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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
