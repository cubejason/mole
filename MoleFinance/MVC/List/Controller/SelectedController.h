//
//  SelectedController.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/13.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,assign)  NSInteger page;
-(void)getData;
@end
