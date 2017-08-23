//
//  NSString+Category.h
//  GraphicalDemo
//
//  Created by BillBo on 2017/8/17.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface NSString (Category)

/**
 高度,宽度 maxfloat

 @param string string description
 @param fontSize fontSize description
 @return return value description
 */
+ (CGFloat)heightForString:(NSString *)string fontSize:(CGFloat)fontSize;

/**
 宽度 ,height maxfloat

 @param string string description
 @param fontSize fontSize description
 @return return value description
 */
+ (CGFloat)widthForString:(NSString *)string fontSize:(CGFloat)fontSize;

@end
