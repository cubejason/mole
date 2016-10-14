//
//  Commond.m
//  MoleFinance
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "Commond.h"

@implementation Commond
// 成交量数值加单位
+(NSString*)changePrice:(CGFloat)price{
    CGFloat newPrice = 0;
    NSString *danwei = @"万";
    if ((int)price>10000) {
        newPrice = price / 10000 ;
    }
    if ((int)price>10000000) {
        newPrice = price / 10000000 ;
        danwei = @"千万";
    }
    if ((int)price>100000000) {
        newPrice = price / 100000000 ;
        danwei = @"亿";
    }
    NSString *newstr = [[NSString alloc] initWithFormat:@"%.0f%@",newPrice,danwei];
    return newstr;
}
//创建一个button
+ (UIButton *)createButtonWithTitle:(NSString *)title  target:(id)target action:(SEL)selector fontSize:(CGFloat)fsize
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (title) {
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:fsize];
    }
    if (target && selector) {
        [button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}
//未点击时的颜色
+(void)setButtonAttr:(UIButton*)button{
    button.backgroundColor = Color(140, 140, 140, 1);
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
//点击后的颜色
+(void)setButtonAttrWithClick:(UIButton*)button{
    button.backgroundColor =Color(180, 180, 180, 1);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
//取出储存在本地的数据
+(NSObject *) getUserDefaults:(NSString *) name{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:name];
}
//把数据写入本地文件
+(void) setUserDefaults:(NSObject *) defaults forKey:(NSString *) key{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:defaults forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
