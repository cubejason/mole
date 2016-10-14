//
//  EditController.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/16.
//  Copyright © 2015年 林庆国. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>
@property NSMutableArray *collection;
@end
