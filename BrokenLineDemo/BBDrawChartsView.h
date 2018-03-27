//
//  BBDrawChartsView.h
//  BrokenLineDemo
//
//  Created by bill.bo on 2018/3/27.
//  Copyright © 2018年 BillBo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBDrawChartsView : UIView

- (instancetype)initWithFrame:(CGRect)frame drawLeftSpace:(CGFloat)drawLeft drawRightSpace:(CGFloat)drawRight  xData:(NSArray *)xData yData:(NSArray *)yData xWidth:(CGFloat)xWidth noDataTips:(NSString *)noDataTips;

@end
