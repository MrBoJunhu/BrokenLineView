//
//  BrokenLineView.m
//  GraphicalDemo
//
//  Created by BillBo on 2017/8/17.
//  Copyright © 2017年 BillBo. All rights reserved.
//
#import "BrokenLineView.h"
#import "NSString+Category.h"

static CGFloat topSpace = 30;

static CGFloat leftSpace = 20;

static CGFloat rightSpace = 20;

static CGFloat bottomSpace = 20;

static CGFloat pointRaidus = 1;

static CGFloat fontSize = 8;

static CGFloat showLBFontSize = 12;

static CGFloat titleFontSize = 18;

static CGFloat wordTopSpace = 2;

@interface BrokenLineView ()

/**
 title
 */
@property (nonatomic, copy) NSString *title;

/**
 Y轴显示的数组
 */
@property (nonatomic, strong) NSMutableArray *YArray;

/**
 横坐标轴文字
 */
@property (nonatomic, strong) NSMutableArray *XArray;

/**
 绘制磨砂效果的Path
 */
@property (nonatomic, strong)  UIBezierPath *bezierPath;

/**
 点击曲线图部分触发事件
 */
@property (nonatomic, strong) NSMutableArray *allPoints;


/**
 展示点击显示的数字
 */
@property (nonatomic, strong) UILabel * showClickLB;


/**
 当前点击的index
 */
@property (nonatomic, assign) NSUInteger currentSelectedIndex;

@end


@implementation BrokenLineView

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title XArray:(NSMutableArray <NSString *>*)xArray YArray:(NSMutableArray <NSNumber *>*)yArray{
    
    if (self = [super initWithFrame:frame]) {
        
        self.YArray = [NSMutableArray arrayWithArray:yArray];
        
        self.XArray = [NSMutableArray arrayWithArray:xArray];
        
        self.title = title;
        
        self.currentSelectedIndex = -1;
        
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
    
}

- (void)drawRect:(CGRect)rect {
    
    self.layer.cornerRadius = 10;
    
    self.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    self.layer.masksToBounds = YES;
    
    CGFloat view_Width = rect.size.width;
    
    CGFloat view_Height = rect.size.height;
    
    
    if (self.title) {
        
        NSDictionary *titleDic = @{
                                   NSFontAttributeName :[UIFont systemFontOfSize:titleFontSize],
                                   NSForegroundColorAttributeName:[UIColor purpleColor]
                                   };
        //绘制title
        CGFloat title_Width = [self stringWidthWithString:self.title attributes:titleDic];
        
        [self.title drawAtPoint:CGPointMake(view_Width/2 - title_Width/2, 0) withAttributes:titleDic];
        
    }
    
    NSArray *X_StringArray = self.XArray;
    
    NSArray *Y_Array = self.YArray;
    
    NSUInteger inputCount = X_StringArray.count > Y_Array.count ? Y_Array.count : X_StringArray.count;
    
    if (inputCount == 0) {
        
        NSString *noDataString = @"无数据";
        
        NSDictionary *noDataDic = @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                    NSForegroundColorAttributeName:[UIColor whiteColor]
                                    };
        
        CGPoint nodataPoint = CGPointMake(self.center.x - [self stringWidthWithString:noDataString attributes:noDataDic]/2, self.center.y - [self stringHeightWithString:noDataString attributes:noDataDic]/2);
        
        [noDataString drawAtPoint:nodataPoint withAttributes:noDataDic];
        
        return;
        
    }
    
    //设置最大值
    CGFloat maxValue = 0;
    CGFloat val = 100;
    
    CGFloat maxValue1 = [[Y_Array valueForKeyPath:@"@max.floatValue"] floatValue];
    
    NSUInteger tempValue = maxValue1/val;
   
    if (tempValue > 0) {
        //100以上
        if (tempValue < 5) {
            
            //500以下
            maxValue = val * 5;
            
        }else if (tempValue < 10){
       
            //1000以下
            maxValue = val * 10;
        
        }else{
            
            //1000以上
            CGFloat upOneThousand = maxValue1 / 1000;
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
               
                CGFloat upTenThousand = maxValue1/tenThousand;
                
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
    
    NSDictionary *attDic = @{
                             NSFontAttributeName :[UIFont systemFontOfSize:fontSize],
                             NSForegroundColorAttributeName : [UIColor blackColor],
                             NSStrokeWidthAttributeName:@5
                             };

    
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    //显示当前极限值
    NSNumber *maxNumber = [NSNumber numberWithFloat:maxValue];
    NSString *maxString = [NSString stringWithFormat:@"Y轴最大值是 : %@", maxNumber];
    [maxString drawAtPoint:CGPointMake(leftSpace + 2, topSpace) withAttributes:attDic];
    
    
    //每个宽度
    CGFloat standard_Width = (view_Width - leftSpace - rightSpace)/(inputCount - 1);
    CGFloat max_Height = view_Height - topSpace - bottomSpace;
    
    
    //坐标轴四个角位置
    CGPoint origin_Point = CGPointMake(leftSpace, topSpace + max_Height);
    CGPoint left_Top_Point = CGPointMake(origin_Point.x, topSpace);
    CGPoint right_Bottom_Point = CGPointMake(view_Width - rightSpace, origin_Point.y);
    
#pragma mark - 绘制坐标轴
    //X轴
    CGPoint  XPoints[2];
    XPoints[0] = origin_Point;
    XPoints[1] = right_Bottom_Point;

    CGContextAddLines(ctx, XPoints, 2);
    //Y轴
//    CGPoint YPoints[2];
//    YPoints[0] = origin_Point;
//    YPoints[1] = left_Top_Point;
//    CGContextAddLines(ctx, YPoints, 2);
//    CGContextDrawPath(ctx, kCGPathStroke);
    
    
    
    //绘制折线的点
    CGPoint totalPoints[inputCount];
    
    //渲染渐变色用到的贝塞尔曲线
    self.bezierPath  = [UIBezierPath bezierPath];
    UIColor *whiteColor = [UIColor whiteColor];
    [whiteColor set];
    self.bezierPath.lineWidth = 2;
    self.bezierPath.lineCapStyle = kCGLineCapRound;
    [self.bezierPath moveToPoint:origin_Point];
    
    self.allPoints = [NSMutableArray array];
    
    for (NSUInteger i = 0; i < inputCount; i ++) {
        
        NSNumber *dataValue = Y_Array[i];
        
        CGFloat dataNum = dataValue.floatValue;
        
        CGFloat x = leftSpace + i * standard_Width;
        
        CGFloat h = max_Height * (dataNum/maxValue);
        
        CGFloat y = topSpace + max_Height - h;
        
        totalPoints[i] = CGPointMake(x, y);
        
        
        [self.bezierPath addLineToPoint:totalPoints[i]];
        
        //点击事件临时存储所有点
        NSValue * pointValue = [NSValue valueWithCGPoint:totalPoints[i]];
        [self.allPoints addObject:pointValue];
        
    }
    
    //最后一个点闭合曲线
    [self.bezierPath addLineToPoint:right_Bottom_Point];
    [self.bezierPath closePath];
  
    //根据坐标点画线
//    [bezierPath stroke];
    //颜色填充
    [self.bezierPath fillWithBlendMode:kCGBlendModeDifference alpha:0.3];

    
    CGContextSetRGBStrokeColor(ctx, 1, 1, 1, 1);
    CGContextSetLineWidth(ctx, 1);
    CGContextAddLines(ctx, totalPoints, inputCount);
    CGContextDrawPath(ctx, kCGPathStroke);
    
#pragma mark - 描绘坐标点
    
    for (NSUInteger i = 0; i < inputCount; i ++) {
        CGPoint po = totalPoints[i];
        
        CGFloat x = po.x;
        CGFloat y = po.y;
        CGContextSetRGBStrokeColor(ctx, 0/255, 0/255, 0/255, 1);
        CGContextSetLineWidth(ctx, 2);
        CGContextAddArc(ctx, x, y, pointRaidus, 0, 2 * M_PI, 0);
        CGContextDrawPath(ctx, kCGPathStroke);

    }
    
#pragma mark - 显示文字
    
    //显示文字

    for (NSUInteger i = 0; i < inputCount; i ++) {
      
        NSNumber *dataValue = Y_Array[i];
        
        NSString *valueString = dataValue.stringValue;
        
        CGFloat string_Width = [NSString widthForString:valueString fontSize:fontSize];
        
        CGFloat string_Height = [NSString heightForString:valueString fontSize:fontSize];
        
        CGFloat string_x = totalPoints[i].x - string_Width/2;
        
        CGFloat string_y = totalPoints[i].y - string_Height;
        
        CGPoint string_Point = CGPointMake(string_x, string_y);
        
        [valueString drawAtPoint:string_Point withAttributes:attDic];

        
        NSString *descriptionString = X_StringArray[i];
        
        CGFloat description_Width = [NSString widthForString:descriptionString fontSize:fontSize];
        
        CGPoint description_Point = CGPointMake(totalPoints[i].x - description_Width/2, origin_Point.y + wordTopSpace);
        
        [descriptionString drawAtPoint:description_Point withAttributes:attDic];
        
        }
    

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = touches.anyObject;
    
    UIView *v = touch.view;
    
    CGPoint touch_Point = [touch locationInView:v];
    
    CGFloat point_x = touch_Point.x;
    
    NSInteger index = 0;
    
    NSInteger totalCount = self.allPoints.count;
    
    CGFloat minDistance = 0;
    
    
    if (touch_Point.y > topSpace) {
        
        for (NSUInteger i = 0 ; i < totalCount; i ++) {
            
            NSValue *value1 = self.allPoints[i];
            
            CGPoint currentPoint = value1.CGPointValue;
            
            CGFloat x1 = currentPoint.x - point_x;
            
            CGFloat distance1 = fabs(x1);

            minDistance = distance1;
            
            if (i < totalCount - 1) {
                
                NSValue *value2 = self.allPoints[i+1];
                
                CGPoint nexPoint = value2.CGPointValue;
                
                CGFloat x2 = nexPoint.x - point_x;
                CGFloat distance2 = fabs(x2);
                
                if (distance2 < distance1) {
                    
                    index = i+1;
                    
                }
                
            }
            
        }
        
        NSValue *pointValue = self.allPoints[index];
        
        CGPoint showPoint = pointValue.CGPointValue;
        
        NSNumber *numb = self.YArray[index];
        
        NSString *numString = numb.stringValue;
        
        if (!self.showClickLB) {
            
            self.showClickLB = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
            
            self.showClickLB.backgroundColor = [UIColor clearColor];
            
            self.showClickLB.textAlignment = NSTextAlignmentCenter;
            
            self.showClickLB.font = [UIFont systemFontOfSize:fontSize];
            
            [self addSubview:self.showClickLB];
            
        }
       
        if (index == self.currentSelectedIndex) {
            
            return;
       
        }else{
        
            self.currentSelectedIndex = index;
        
        }
        
        self.showClickLB.alpha = 0;
        
        self.showClickLB.text = numString;
        
        self.showClickLB.center = showPoint;
        
        [UIView animateWithDuration:0.5 animations:^{
          
            self.showClickLB.center = CGPointMake(showPoint.x, 50);
            
            self.showClickLB.alpha = 1.0;
            
            self.showClickLB.font = [UIFont systemFontOfSize:showLBFontSize];
        
        }];

        
    }else{
        
        return;
    }
    
}

#pragma mark - public method

- (CGFloat)stringWidthWithString:(NSString *)string attributes:(NSDictionary *)attributes{
    
    return [self rectOfString:string attributes:attributes].size.width;
    
}

- (CGFloat)stringHeightWithString:(NSString *)string attributes:(NSDictionary *)attributes{
    
    return [self rectOfString:string attributes:attributes].size.height;
    
}


- (CGRect)rectOfString:(NSString *)string attributes:(NSDictionary *)attributes{
    
    return [string boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil];
    
}


@end
