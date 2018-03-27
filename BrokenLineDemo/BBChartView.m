//
//  BBChartView.m
//  BBChartViewDeom
//
//  Created by bill.bo on 2018/3/22.
//  Copyright © 2018年 bill.bo. All rights reserved.
//

#import "BBChartView.h"
#import "BBDrawChartsView.h"

@interface BBChartView(){
    
    CGFloat pinchScales;
    
}

@end

@implementation BBChartView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title xData:(NSArray *)xData yData:(NSArray *)yData xWidth:(CGFloat)xWidth noDataTips:(NSString *)noDataTips {

    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat leftSpace = 0;
        
        CGFloat rightSpace = 0;
        
        CGFloat topSpace = 20;
        
        NSUInteger count = xData.count >= yData.count ? yData.count : xData.count;
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, topSpace)];
        
        titleLB.font = [UIFont systemFontOfSize:15];
        
        titleLB.textColor = [UIColor whiteColor];
        
        titleLB.textAlignment = NSTextAlignmentCenter;
        
        titleLB.text = title;
        
        [self addSubview:titleLB];

        if (count) {
            
            UIScrollView *scv = [[UIScrollView alloc] initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(titleLB.frame), frame.size.width -  leftSpace - rightSpace, frame.size.height - CGRectGetHeight(titleLB.frame))];
            
            scv.showsHorizontalScrollIndicator = NO;
            
            CGFloat drawLeftSpace = 20;
            
            CGFloat drawRightSpace = 20;
            
            CGFloat content_W = drawLeftSpace + drawRightSpace + xWidth * (count - 1);
                        
            scv.contentSize = CGSizeMake(content_W, scv.frame.size.height);
            
            [self addSubview:scv];
            
            BBDrawChartsView *charV = [[BBDrawChartsView alloc] initWithFrame:CGRectMake(0, 0, content_W, scv.frame.size.height) drawLeftSpace:drawLeftSpace drawRightSpace:drawRightSpace xData:xData yData:yData xWidth:xWidth noDataTips:noDataTips];
            
            UIPinchGestureRecognizer *pinG = [[UIPinchGestureRecognizer alloc] init];
            
            [pinG addTarget:self action:@selector(addPinFunciton:)];
            
            [charV addGestureRecognizer:pinG];
            
            [scv addSubview:charV];
       
        }
        
    }
    
    return self;
    
}


- (void)addPinFunciton:(UIPinchGestureRecognizer *)sender{
    
    NSLog(@"%f", sender.scale);
    
}



- (void)drawRect:(CGRect)rect {
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    layer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    layer.colors = @[(id)[UIColor cyanColor].CGColor,(id)[UIColor orangeColor].CGColor, (id)[UIColor orangeColor].CGColor];
    
    layer.startPoint = CGPointMake(0, 0);
    
    layer.endPoint = CGPointMake(0, 1);
    
    [self.layer insertSublayer:layer atIndex:0];
  
}


@end
