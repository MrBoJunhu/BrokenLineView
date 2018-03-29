//
//  BBDrawChartsView.m
//  BrokenLineDemo
//
//  Created by bill.bo on 2018/3/27.
//  Copyright © 2018年 BillBo. All rights reserved.
//

#import "BBDrawChartsView.h"


@interface BBDrawChartsView(){
    NSUInteger _inputCount;
    CGPoint _originPoint;
}

@property (nonatomic, strong) NSMutableArray *x_Array;

@property (nonatomic, strong) NSMutableArray *y_Array;

@property (nonatomic, assign) CGFloat xWidth;

@property (nonatomic, copy) NSString  *noDataTips;

@property (nonatomic, strong) NSMutableArray *allPointsArray;

@property (nonatomic, assign) CGFloat leftSpace;

@property (nonatomic, assign) CGFloat rightSpace;

@property (nonatomic, assign) CGFloat topSpace;

@property (nonatomic, assign) CGFloat bottomSpace;

/**
 展示点击显示的数字
 */
@property (nonatomic, strong) UILabel * showClickLB;

/**
 当前点击的index
 */
@property (nonatomic, assign) NSUInteger currentSelectedIndex;

@end

@implementation BBDrawChartsView


- (instancetype)initWithFrame:(CGRect)frame drawLeftSpace:(CGFloat)drawLeft drawRightSpace:(CGFloat)drawRight xData:(NSArray *)xData yData:(NSArray *)yData xWidth:(CGFloat)xWidth noDataTips:(NSString *)noDataTips {
    
    if (self = [super initWithFrame:frame]) {
        
        _currentSelectedIndex = -1;
        
        _leftSpace = drawLeft;
        
        _rightSpace = drawRight;
        
        _topSpace = 10;
        
        _bottomSpace = 20;
        
        self.x_Array = [NSMutableArray arrayWithArray:xData];
        
        self.y_Array = [NSMutableArray arrayWithArray:yData];
        
        _inputCount = self.x_Array.count >= self.y_Array.count ? self.y_Array.count : self.x_Array.count;
        
        self.backgroundColor = [UIColor clearColor];
        
        self.xWidth = xWidth;
        
        self.noDataTips = noDataTips;
        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat content_H = rect.size.height;
    
    CGFloat content_W = rect.size.width;
    
    CGFloat drawHeight = content_H -  _topSpace - _bottomSpace;
    
    NSArray *tempYArray = [NSArray arrayWithArray:self.y_Array];
    
    [self.y_Array removeAllObjects];
    
    [tempYArray enumerateObjectsUsingBlock:^(NSString *objStr, NSUInteger idx, BOOL * _Nonnull stop) {
        
        NSNumber *number = [NSNumber numberWithFloat:objStr.floatValue];
        
        [self.y_Array addObject:number];
        
    }];
    
    if (_inputCount == 0) {
        
        NSDictionary *nodataAttributeDic = @{NSFontAttributeName:[UIFont systemFontOfSize:18],
                                             NSForegroundColorAttributeName : [UIColor whiteColor]
                                             };
        CGFloat nodataStringWidth = [self widthOfString:self.noDataTips attributes:nodataAttributeDic];
        
        CGFloat nodataStringHeight = [self heightOfString:self.noDataTips attributes:nodataAttributeDic];
        
        [self.noDataTips drawAtPoint:CGPointMake(content_W/2 - nodataStringWidth/2, content_H/2 - nodataStringHeight/2) withAttributes:nodataAttributeDic];
        
        
    }
    
    CGFloat maxValue = [[self.y_Array valueForKeyPath:@"@max.floatValue"] floatValue];
    
    CGFloat minValue = [[self.y_Array valueForKeyPath:@"@min.floatValue"] floatValue];
    
    CGFloat totalValue = (maxValue - minValue) >= maxValue ? (maxValue - minValue) : maxValue;
    
    totalValue = [self resetMaxRangeValue:totalValue];
    
    CGFloat minimumRange = fabs(totalValue);
    
    NSUInteger minimumDrawRange = abs((int)minimumRange);
    
    
    
    CGFloat percent_H = drawHeight/minimumDrawRange;
    
    _originPoint = CGPointMake(_leftSpace, content_H - _bottomSpace);
    
    if (minValue < 0) {
        
        //包含负数
        _originPoint = CGPointMake(_leftSpace, _originPoint.y - percent_H * (fabs(minValue)));
        
    }
    
    CGPoint rightBottomPoint = CGPointMake(content_W - _rightSpace, _originPoint.y);
    
    // X轴
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGPoint XPoints[2];
    XPoints[0] = _originPoint;
    XPoints[1] = rightBottomPoint;
    CGContextSetStrokeColorWithColor(contextRef, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(contextRef, 1);
    CGContextMoveToPoint(contextRef, _originPoint.x, _originPoint.y);
    CGContextAddLines(contextRef, XPoints, 2);
    CGContextStrokePath(contextRef);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    
    bezierPath.lineWidth = 2;
    
    bezierPath.lineCapStyle = kCGLineCapRound;
    
    [bezierPath moveToPoint:_originPoint];
    
    CGPoint totalPoints[_inputCount];
    
    self.allPointsArray = [NSMutableArray array];
    
    for (NSUInteger i = 0 ; i < _inputCount; i++) {
        
        NSNumber *dataValue = self.y_Array[i];
        
        CGFloat dataNum = dataValue.floatValue;
        
        CGFloat x = _leftSpace + i * self.xWidth;
        
        CGFloat y ;
        
        if (dataNum >= 0 ) {
            
            y =  _originPoint.y - percent_H * dataNum;
            
        }else{
            
            y = _originPoint.y +  percent_H * fabs(dataNum);
            
        }
        
        CGPoint p = CGPointMake(x, y);

        NSValue *pointValue = [NSValue valueWithCGPoint:p];
        
        [self.allPointsArray addObject:pointValue];
        
        totalPoints[i] = p;
        
        [bezierPath addLineToPoint:totalPoints[i]];
        
    }
    
    UIColor *pathColor = [UIColor whiteColor];
    
    [pathColor set];
    
    [bezierPath addLineToPoint:rightBottomPoint];
    
    [bezierPath fillWithBlendMode:kCGBlendModeDifference alpha:0.5];
    
    [bezierPath closePath];
    
    // draw x  y string
    NSDictionary *xWordAttributeDic = @{
                                        NSFontAttributeName :[UIFont systemFontOfSize:8],
                                        NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSStrokeWidthAttributeName:@8
                                        };
    
    NSDictionary *yWordAttributeDic = @{
                                        NSFontAttributeName :[UIFont systemFontOfSize:10],
                                        NSForegroundColorAttributeName : [UIColor whiteColor],
                                        NSStrokeWidthAttributeName:@8
                                        };

    for (NSUInteger i = 0; i < tempYArray.count; i++) {
        
        NSValue *pointValue = self.allPointsArray[i];
        
        CGPoint p = pointValue.CGPointValue;
        
        CGContextSetRGBStrokeColor(contextRef, 255/255, 255/255, 255/255, 1);
        
        CGContextSetLineWidth(contextRef, 2);
        
        CGContextAddArc(contextRef, p.x, p.y, 1, 0, 2 * M_PI, 0);
        
        CGContextDrawPath(contextRef, kCGPathStroke);
       
//        UIBezierPath *pointPath = [UIBezierPath bezierPathWithArcCenter:p radius:1 startAngle:0 endAngle:2*M_PI clockwise:YES];
//
//        pointPath.lineWidth = 2.0;
//
//        pointPath.lineCapStyle = kCGLineCapRound;
//
//        pointPath.lineJoinStyle = kCGLineJoinRound;
//
//        [pointPath stroke];

        
        NSString *yString = tempYArray[i];
        
        CGFloat yString_W = [self widthOfString:yString attributes:yWordAttributeDic];
        
        CGFloat yString_H = [self heightOfString:yString attributes:yWordAttributeDic];
        
        CGFloat yString_Origin_Y = yString.floatValue >= 0 ? p.y - yString_H : p.y + yString_H/2;
        
        [yString drawAtPoint:CGPointMake(p.x - yString_W/2, yString_Origin_Y) withAttributes:yWordAttributeDic];
        
        NSString *xString = self.x_Array[i];
        
        CGFloat xString_W = [self widthOfString:xString attributes:xWordAttributeDic];
        
        CGFloat xString_Height = [self heightOfString:xString attributes:xWordAttributeDic];
        
        [xString drawAtPoint:CGPointMake(p.x - xString_W/2, _originPoint.y + xString_Height/2) withAttributes:xWordAttributeDic];

    }
    
}

- (CGRect)rectOfString:(NSString *)givenString size:(CGSize)size attributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes {
    
    return [givenString boundingRectWithSize:size options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    
}

- (CGFloat)widthOfString:(NSString *)givenString attributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes {
    
    return [self rectOfString:givenString size:CGSizeMake(MAXFLOAT, MAXFLOAT)  attributes:attributes].size.width;
    
}

- (CGFloat)heightOfString:(NSString *)givenString attributes:(nullable NSDictionary<NSAttributedStringKey,id> *)attributes {
    return [self rectOfString:givenString size:CGSizeMake(MAXFLOAT, MAXFLOAT) attributes:attributes].size.height;
}


- (CGFloat)resetMaxRangeValue:(CGFloat)maxValue{
    
    CGFloat val = 1;
    
    NSUInteger tempValue = maxValue/val;
    
    if (tempValue > 0) {
        
        if (tempValue <= 1) {
            
            maxValue = 1;
            
        }else if (tempValue >= 5) {
            
            maxValue = val * (tempValue + 1);
            
        }else if (tempValue < 10){
            
            //1000以下
            maxValue = val * 10;
            
        }else{
            
            //1000以上
            CGFloat upOneThousand = maxValue / 1000;
            CGFloat oneThousand = 1000;
            
            if (upOneThousand < 5) {
                
                //5000以下
                maxValue = oneThousand * 5;
                
            }else if (upOneThousand < 10){
                
                //10000以下
                maxValue = oneThousand * 10;
                
            }else{
                
                //10000以上
                CGFloat tenThousand = 10000;
                
                CGFloat upTenThousand = maxValue/tenThousand;
                
                if (upOneThousand < 5) {
                    
                    maxValue = 5 * tenThousand;
                    
                }else if (upTenThousand < 10){
                    
                    maxValue = 10 * tenThousand;
                    
                }else{
                    
                    maxValue = (upTenThousand + 1) * tenThousand;
                    
                }
                
            }
            
        }
        
    }else{
        
        //100以下
        maxValue = val;
        
    }
    
    return maxValue;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    return;
    
    UITouch *touch = touches.anyObject;
    
    UIView *v = touch.view;
    
    CGPoint touch_Point = [touch locationInView:v];
    
    CGFloat point_x = touch_Point.x;
    
    NSInteger index = 0;
    
    NSInteger totalCount = self.allPointsArray.count;
    
    CGFloat minDistance = 0;
    
    if (touch_Point.y > _topSpace) {
        
        for (NSUInteger i = 0 ; i < totalCount; i ++) {
            
            NSValue *value1 = self.allPointsArray[i];
            
            CGPoint currentPoint = value1.CGPointValue;
            
            CGFloat x1 = currentPoint.x - point_x;
            
            CGFloat distance1 = fabs(x1);
            
            minDistance = distance1;
            
            if (i < totalCount - 1) {
                
                NSValue *value2 = self.allPointsArray[i+1];
                
                CGPoint nexPoint = value2.CGPointValue;
                
                CGFloat x2 = nexPoint.x - point_x;
                
                CGFloat distance2 = fabs(x2);
                
                if (distance2 < distance1) {
                    
                    index = i+1;
                    
                }
                
            }
            
        }
        
        NSValue *pointValue = self.allPointsArray[index];
        
        CGPoint showPoint = pointValue.CGPointValue;
        
        NSNumber *y_Num = self.y_Array[index];
        
        NSString *numString = y_Num.stringValue;
        
        if (!self.showClickLB) {
            
            self.showClickLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
            
            self.showClickLB.backgroundColor = [UIColor clearColor];
            
            self.showClickLB.textAlignment = NSTextAlignmentCenter;
            
            self.showClickLB.font = [UIFont systemFontOfSize:6];
            
            self.showClickLB.textColor = [UIColor whiteColor];
            
            [self addSubview:self.showClickLB];
            
        }
        
        if (index == self.currentSelectedIndex) {
            
            return;
            
        }else{
            
            self.currentSelectedIndex = index;
            
        }
        
        self.showClickLB.alpha = 0;
        
        self.showClickLB.text = numString;
        
        self.showClickLB.center = CGPointMake(showPoint.x, _originPoint.y);
        
        [UIView animateWithDuration:0.5 animations:^{
            
            self.showClickLB.center = showPoint;
            
            self.showClickLB.alpha = 1.0;
            
            self.showClickLB.font = [UIFont systemFontOfSize:12];
            
        }];
        
        
    }else{
        
        return;
    }
    
}

@end
