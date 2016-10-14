//
//  EditController.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/16.
//  Copyright © 2015年 林庆国. All rights reserved.
//

#import "EditController.h"
#import "EditCell.h"
#import "StockModel.h"
static NSString *cellID=@"edit";
@interface EditController ()
{
    UITableView *tab;
    EditCell *cell;
    BOOL state;
}

@end

@implementation EditController

- (void)viewDidLoad {
    [self setupNavigationBar];
    tab=[[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    [self.view addSubview:tab];
    //可以编辑
    tab.editing=YES;
    //控制是否可以移动
    state=NO;
    tab.delegate=self;
    tab.dataSource=self;
    [tab registerNib:[UINib nibWithNibName:@"EditCell"  bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellID ];
}
-(void)setupNavigationBar{
    UIButton *returnBack=[Commond createButtonWithTitle:@"返回" target:self action:@selector(returnBack_touch) fontSize:18];
    [returnBack setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    returnBack.frame=CGRM(0, 0, 60, 30);
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:returnBack];
    UIButton *remove=[Commond createButtonWithTitle:@"删除" target:self action:@selector(remove_touch) fontSize:18];
    [remove setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    remove.frame=CGRM(0, 0, 60, 30);
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:remove];
}
//tableView的相关函数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _collection.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    cell=[tableView dequeueReusableCellWithIdentifier:cellID];
   //至关重要的一段话
    //所有关于scroll上控件添加手势都需要
    for (id obj in cell.subviews) {
        if ([NSStringFromClass([obj class]) isEqual:@"UITableViewCellScrollView"]) {
            UIScrollView *scroll=(UIScrollView*)obj;
            scroll.canCancelContentTouches = NO;//是否可以中断touches
            scroll.delaysContentTouches = NO;//是否延迟touches事件
            break;
        }
    }
    //移动cell需要
    cell.showsReorderControl =YES;
    StockModel *model=_collection[indexPath.row];
    cell.name.text=model.name;
    cell.code.text=model.code;
    //置顶按钮、点击
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
    tap.delegate=self;
    cell.top.userInteractionEnabled=YES;
    [cell.top addGestureRecognizer:tap];
    cell.top.tag=1000+indexPath.row;
    //移动按钮、长按
//    UILongPressGestureRecognizer *longPress =
//    [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
//    longPress.delegate=self;
    //[cell.move addGestureRecognizer:longPress];
//    cell.move.userInteractionEnabled=YES;
    return cell;
}
//点击置顶
- (void)tapGesture:(UITapGestureRecognizer *)tap{
    NSLog(@"tap!");
    //手势的view属性，能够拿到手势所在的视图
    UIView *view = tap.view;
    NSUInteger fromRow =view.tag-1000;    //要移动的位置
    NSUInteger toRow = 0; //移动的目的位置
    id object = [_collection objectAtIndex:fromRow]; //存储将要被移动的位置的对象
    [_collection removeObjectAtIndex:fromRow];       //将对象从原位置移除
    [_collection insertObject:object atIndex:toRow]; //将对象插入到新位置
    [tab reloadData]; //刷新tableview
    //改变本地数据
    NSMutableArray *arr=[NSMutableArray arrayWithArray:(NSArray*)[Commond getUserDefaults:@"myStock"]];
    [arr exchangeObjectAtIndex:fromRow withObjectAtIndex:toRow];
    [Commond setUserDefaults:arr forKey:@"myStock"];
}
//- (void)longPressGesture:(UITapGestureRecognizer *)longPress{
//    NSLog(@"longPress");
//    state=YES;
//}
//返回
-(void)returnBack_touch{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
//一次删除所有被选中的cell
-(void)remove_touch{
    NSArray *selectedIndexPaths = [tab indexPathsForSelectedRows];
    
    //index 的集合
    NSMutableIndexSet *indexes = [[NSMutableIndexSet alloc] init];
    
    //index 变成了index.row/可以被使用
    for (NSIndexPath *ind in selectedIndexPaths) {
        [indexes addIndex:ind.row];
    }
    //数组的方法
    //一次性删除大量的元素
    [_collection removeObjectsAtIndexes:indexes];
    
    //改变本地数据
    NSMutableArray *arr=[NSMutableArray arrayWithArray:(NSArray*)[Commond getUserDefaults:@"myStock"]];
    [arr removeObjectsAtIndexes:indexes];
    [Commond setUserDefaults:arr forKey:@"myStock"];
    
    //    for (int i=selectedIndexPaths.count-1; i>=0; i--) {
    //        [collection removeObjectAtIndex:selectedIndexPaths[i].row];
    //    }
    
    [tab deleteRowsAtIndexPaths:selectedIndexPaths withRowAnimation:UITableViewRowAnimationTop];
}

#pragma mark------关于删除和移动的相关方法----------
//确认编辑类型
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
  return UITableViewCellEditingStyleInsert | UITableViewCellEditingStyleDelete;
}
//指定该行能够移动
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
//移动方法
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
{
    NSUInteger fromRow = [sourceIndexPath row];    //要移动的位置
    NSUInteger toRow = [destinationIndexPath row]; //移动的目的位置
    id object = [_collection objectAtIndex:fromRow]; //存储将要被移动的位置的对象
    [_collection removeObjectAtIndex:fromRow];       //将对象从原位置移除
    [_collection insertObject:object atIndex:toRow]; //将对象插入到新位置
    //改变本地数据
    NSMutableArray *arr=[NSMutableArray arrayWithArray:(NSArray*)[Commond getUserDefaults:@"myStock"]];
    [arr exchangeObjectAtIndex:fromRow withObjectAtIndex:toRow];
    [Commond setUserDefaults:arr forKey:@"myStock"];
}
////删除cell方法
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    NSUInteger row = [indexPath row]; //获取当前行
//    [_collection removeObjectAtIndex:row]; //在数据中删除当前对象
//    [tab deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];//数组执行删除操作
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
