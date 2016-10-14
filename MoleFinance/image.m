//
//  image.m
//  MoleFinance
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 林庆国. All rights reserved.
//

#import "image.h"

@implementation image
+ (UIImage *)reSizeImage:(UIImage *)image toSize:(CGSize)reSize


{
    
    UIGraphicsBeginImageContext(CGSizeMake(reSize.width, reSize.height));
    
    [image drawInRect:CGRectMake(0, 0, reSize.width, reSize.height)];
    
    UIImage *reSizeImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    
    
    return reSizeImage;
    
    
    
}

@end
