//
//  BBChartView.h
//  BBChartViewDeom
//
//  Created by bill.bo on 2018/3/22.
//  Copyright © 2018年 bill.bo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBChartView : UIView

- (instancetype)initWithFrame:(CGRect)frame  title:(NSString *)title xData:(NSArray *)xData yData:(NSArray *)yData xWidth:(CGFloat)xWidth noDataTips:(NSString *)noDataTips;

@end
