
//
//  baseController.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/14.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface baseController : UIViewController
@property (weak, nonatomic) IBOutlet UIScrollView *baseScroll;
@property (weak, nonatomic) IBOutlet UILabel *Basetitle;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (nonatomic,copy)NSString *urlString;
@property (nonatomic,assign)NSInteger *tagget;
@end
