//
//  ViewController.m
//  BrokenLineDemo
//
//  Created by BillBo on 2017/8/23.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "ViewController.h"
#import "BrokenBasicView.h"
#import "BBChartView.h"
@interface ViewController ()

/**
 折线图
 */
@property (nonatomic, strong) BrokenBasicView * brokenLineV;


@end

@implementation ViewController

- (void)viewDidLoad {
   
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"微信运动步数";
    
    [self brokenLineTest];

}

- (void)brokenLineTest {
    
    NSArray *X_StringArray = @[@"1",@"2",@"23",@"12",@""];
    
    NSArray *Y_Array = @[@983,@300,@800];
    
    self.brokenLineV = [[BrokenBasicView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 200) title:@"测试数据" XArray:[X_StringArray mutableCopy] YArray:[Y_Array mutableCopy]];
   
    [self.view addSubview:self.brokenLineV];
    
    
    NSArray *xData = @[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月",@"一月",@"二月",@"三月",@"四月",@"五月",@"六月",@"七月",@"八月",@"九月",@"十月"];
    
    NSArray *yData = @[@"10",@"1.2",@"0.1",@"-0.8",@"1",@"1.2",@"0.1",@"-0.8",@"1",@"-5",@"0.1",@"-0.8"];
    
    BBChartView *chartView = [[BBChartView alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.brokenLineV.frame), self.view.frame.size.width - 40, 200) title:@"体重" xData:xData yData:yData xWidth:50 noDataTips:@"暂无数据哦"];
    
    [self.view addSubview:chartView];

    
}

- (void)viewDidLayoutSubviews {
    
    self.brokenLineV.frame = CGRectMake(0, self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, 200);
    
}

- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];

}


@end
