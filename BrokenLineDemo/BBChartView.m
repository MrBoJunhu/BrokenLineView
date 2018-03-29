//
//  BBChartView.m
//  BBChartViewDeom
//
//  Created by bill.bo on 2018/3/22.
//  Copyright © 2018年 bill.bo. All rights reserved.
//

#import "BBChartView.h"
#import "BBDrawChartsView.h"
#import "UIColor+VJExtension.h"


static CGFloat MaxScales = 1.5;
static CGFloat MinScales = 1;
static CGFloat drawLeftSpace = 20;
static CGFloat drawRightSpace = 20;

@interface BBChartView(){
    CGFloat _totalScales;
    NSUInteger _count;
    CGFloat _XWidth;
}

@property (nonatomic, strong) UIScrollView *scv;

@property (nonatomic, strong)  BBDrawChartsView *charV;

@end

@implementation BBChartView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title xData:(NSArray *)xData yData:(NSArray *)yData xWidth:(CGFloat)xWidth noDataTips:(NSString *)noDataTips {

    if (self = [super initWithFrame:frame]) {
        
        _totalScales = 1;
        
        _XWidth = xWidth;
        
        self.backgroundColor = [UIColor clearColor];
        
        CGFloat leftSpace = 0;
        
        CGFloat rightSpace = 0;
        
        CGFloat topSpace = 20;
        
        _count = xData.count >= yData.count ? yData.count : xData.count;
        
        UILabel *titleLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, topSpace)];
        
        titleLB.font = [UIFont systemFontOfSize:15];
        
        titleLB.textColor = [UIColor whiteColor];
        
        titleLB.textAlignment = NSTextAlignmentCenter;
        
        titleLB.text = title;
        
        [self addSubview:titleLB];

        if (_count) {
            
            _scv = [[UIScrollView alloc] initWithFrame:CGRectMake(leftSpace, CGRectGetMaxY(titleLB.frame), frame.size.width -  leftSpace - rightSpace, frame.size.height - CGRectGetHeight(titleLB.frame))];
            
            _scv.showsHorizontalScrollIndicator = NO;
            
            CGFloat content_W = drawLeftSpace + drawRightSpace + xWidth * (_count - 1);
                        
            _scv.contentSize = CGSizeMake(content_W, _scv.frame.size.height);
            
            [self addSubview:_scv];
         
            _charV  = [[BBDrawChartsView alloc] initWithFrame:CGRectMake(0, 0, content_W, _scv.frame.size.height) drawLeftSpace:drawLeftSpace drawRightSpace:drawRightSpace xData:xData yData:yData xWidth:xWidth noDataTips:noDataTips];
            
            UIPinchGestureRecognizer *pinG = [[UIPinchGestureRecognizer alloc] init];
            
            [pinG addTarget:self action:@selector(addPinFunciton:)];
            
            [_charV addGestureRecognizer:pinG];
            
            [_scv addSubview:_charV];
       
        }
        
    }
    
    return self;
    
}


- (void)addPinFunciton:(UIPinchGestureRecognizer *)sender{
    
    CGFloat scales = sender.scale;
    
    if (scales > 1 && _totalScales > MaxScales) {
        return;
    }
    
    if (scales < 1 && _totalScales < MinScales)  {
        return;
    }
    
    _XWidth *= scales;
    
    CGSize scvContentSize = CGSizeMake(drawLeftSpace + drawRightSpace + _XWidth * (_count - 1),_scv.frame.size.height);
    
    _scv.contentSize = scvContentSize;
    
    CGRect chartFrame = CGRectMake(_charV.frame.origin.x, _charV.frame.origin.y,scvContentSize.width , scvContentSize.height);
    
    _charV.frame = chartFrame;
    
    _totalScales *= scales;
    
    sender.scale = 1;
    
}


- (void)drawRect:(CGRect)rect {
    
    CAGradientLayer *layer = [CAGradientLayer layer];
    
    layer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    
    UIColor *bustHighColor = [UIColor vj_colorWithHex:0xFF77BA2B];
    
    UIColor *bustLowColor = [UIColor vj_colorWithHex:0xFFA6C225];

    layer.colors = @[(id)bustHighColor.CGColor, (id)bustLowColor.CGColor];
    
    layer.startPoint = CGPointMake(0, 0);
    
    layer.endPoint = CGPointMake(0, 1);
    
    [self.layer insertSublayer:layer atIndex:0];
  
}


@end
