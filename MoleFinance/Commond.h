//
//  Commond.h
//  MoleFinance
//
//  Created by qianfeng on 15/10/12.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Commond : NSObject
+(NSString*)changePrice:(CGFloat)price;
+ (UIButton *)createButtonWithTitle:(NSString *)title  target:(id)target action:(SEL)selector fontSize:(CGFloat)fsize;
+(void)setButtonAttr:(UIButton*)button;
+(void)setButtonAttrWithClick:(UIButton*)button;
+(NSObject *) getUserDefaults:(NSString *) name;
+(void) setUserDefaults:(NSObject *) defaults forKey:(NSString *) key;
@end
