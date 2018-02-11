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
    
    NSArray *X_StringArray = @[@"1",@"2",@"23",@"12",@""];
    
    NSArray *Y_Array = @[@983,@300,@800];
    
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
