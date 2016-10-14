//
//  StockCell.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StockModel.h"
@interface StockCell : UITableViewCell
@property (nonatomic)StockModel *model;
@property  UILabel *name;
@property  UILabel *number;
@property  UILabel *curPrice;
@property  UILabel *percent;
@property  UILabel *step;

@end
