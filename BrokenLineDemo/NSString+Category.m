//
//  NSString+Category.m
//  GraphicalDemo
//
//  Created by BillBo on 2017/8/17.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "NSString+Category.h"

@implementation NSString (Category)

+ (CGFloat)heightForString:(NSString *)string fontSize:(CGFloat)fontSize {
    
    if (string.length > 0 ) {
        
        return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSAttachmentAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size.height;

    }
    return 0;
}

+ (CGFloat)widthForString:(NSString *)string fontSize:(CGFloat)fontSize {
    
    if (string.length > 0 ) {
        
        return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSAttachmentAttributeName : [UIFont systemFontOfSize:fontSize]} context:nil].size.width;
    }
    
    return 0;
    
}

@end
