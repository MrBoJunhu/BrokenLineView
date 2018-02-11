//
//  BrokenBasicView.m
//  GraphicalDemo
//
//  Created by BillBo on 2017/8/17.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "BrokenBasicView.h"
#import "BrokenLineView.h"

@interface BrokenBasicView()

@property (nonatomic, strong) BrokenLineView *lineVeiw ;


@end


@implementation BrokenBasicView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title XArray:(NSMutableArray <NSString *>*)xArray YArray:(NSMutableArray <NSNumber *>*)yArray{
    
    if (self = [super initWithFrame:frame]) {
        
        self.lineVeiw = [[BrokenLineView alloc] initWithFrame:self.bounds title:title XArray:xArray YArray:yArray];

        [self addSubview:_lineVeiw];
        
    }
    
    return self;
    
}

- (void)layoutSubviews {
    
    self.lineVeiw.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    [_lineVeiw setNeedsDisplay];

}


- (void)drawRect:(CGRect)rect {
   
    self.layer.cornerRadius = 5;
    
    self.layer.masksToBounds = YES;
    
    // 创建Quartz上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //创建色彩空间对象
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    
    //创建起点颜色
    CGColorRef beginColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.3f, 0.73f,0.53f, 1.0f});
    
    //创建终点颜色
    CGColorRef endColor = CGColorCreate(colorSpaceRef, (CGFloat[]){0.13f, 0.61f, 0.62f, 1.0f});
    
    //创建颜色数组
    CFArrayRef colorArray = CFArrayCreate(kCFAllocatorDefault, (const void*[]){beginColor, endColor}, 2, nil);
    
    CGGradientRef gradientRef = CGGradientCreateWithColors(colorSpaceRef, colorArray, (CGFloat[]){
        0.0f,       // 对应起点颜色位置
        1.0f        // 对应终点颜色位置
    });
    
    // 释放颜色数组
    CFRelease(colorArray);
    
    // 释放起点和终点颜色
    CGColorRelease(beginColor);
    CGColorRelease(endColor);
    
    // 释放色彩空间
    CGColorSpaceRelease(colorSpaceRef);
    
    CGContextDrawLinearGradient(ctx, gradientRef, CGPointMake(0.0f, 0.0f), CGPointMake(rect.size.width, rect.size.height), 0);
    
    // 释放渐变对象
    CGGradientRelease(gradientRef);
    
    [self.layer addSublayer:self.lineVeiw.layer];

}

@end
