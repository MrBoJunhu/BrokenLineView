//
//  ViewController.m
//  BrokenLineDemo
//
//  Created by BillBo on 2017/8/23.
//  Copyright © 2017年 BillBo. All rights reserved.
//

#import "ViewController.h"
#import "BrokenBasicView.h"
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
    
    NSArray *X_StringArray = @[@"1月",@"2月",@"3月",@"4月",@"5月",@"6月",@"7月"];
    
    NSArray *Y_Array = @[@500.5,@300,@2500,@603,@745,@500,@900];
    
    self.brokenLineV = [[BrokenBasicView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 300) title:@"测试数据" XArray:[X_StringArray mutableCopy] YArray:[Y_Array mutableCopy]];
    
    [self.view addSubview:self.brokenLineV];
    
    [self.brokenLineV setNeedsDisplay];
    
}


- (void)viewDidLayoutSubviews {
    
    self.brokenLineV.center = self.view.center;
    
}

- (void)didReceiveMemoryWarning {
   
    [super didReceiveMemoryWarning];

}


@end
