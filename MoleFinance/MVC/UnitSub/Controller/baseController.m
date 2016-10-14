//
//  baseController.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/14.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "baseController.h"
#import "InvestData.h"
@interface baseController ()
{
    NSDictionary *collection;
    
}

@end

@implementation baseController

- (void)viewDidLoad {
  self.view.backgroundColor=[UIColor orangeColor];
    //self.baseScroll.backgroundColor=[UIColor redColor];
    [self getData];
}

- (IBAction)returnBack:(id)sender {
    //NSLog(@"可以跳转");
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark------得到数据----------
-(void)getData{
    
    InvestData *inv=[[InvestData alloc]init];
    
    if (self.tagget == 1) {
        inv.live=^(NSDictionary* dic){
            collection=dic[@"news"];
            //print(collection)
            //NSLog(@"----在直播-----");
            [self fillDataToLable];
        };
    }
    if (self.tagget==2) {
        inv.live=^(NSDictionary* dic){
            collection=dic[@"reportIndustry"];
            //print(collection)
            //NSLog(@"----在直播-----");
            [self fillDataToLable];
        };
    }

    [inv getLiveData:self.urlString];
}
//填充数据
-(void)fillDataToLable{
    if (self.tagget==1) {
        self.Basetitle.text=collection[@"title"];
        self.time.text=collection[@"showtime"];
        
        CGSize size=[collection[@"body"] boundingRectWithSize:CGSizeMake(self.content.frame.size.width, MAXFLOAT)   options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        //NSLog(@"高为#####%f",size.height);
        CGRect rect=self.content.frame;
        rect.size.height=size.height;
        self.content.frame=rect;
        
        self.baseScroll.contentSize=CGSizeMake(WIDTH, CGRectGetMaxY(self.content.frame));
        
        //    NSLog(@"####%f",self.content.frame.size.height);
        //self.content.backgroundColor=[UIColor yellowColor];
        self.content.text=collection[@"body"];
    }
    
    if (self.tagget==2) {
        self.Basetitle.text=collection[@"title"];
        self.time.text=collection[@"declaredate"];
        
        CGSize size=[collection[@"content"] boundingRectWithSize:CGSizeMake(self.content.frame.size.width, MAXFLOAT)   options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        //NSLog(@"高为#####%f",size.height);
        CGRect rect=self.content.frame;
        rect.size.height=size.height;
        self.content.frame=rect;
        
        self.baseScroll.contentSize=CGSizeMake(WIDTH, CGRectGetMaxY(self.content.frame));
        
        //    NSLog(@"####%f",self.content.frame.size.height);
        self.content.backgroundColor=[UIColor yellowColor];
        self.content.text=collection[@"content"];
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
