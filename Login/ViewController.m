//
//  ViewController.m
//  Login
//
//  Created by philia on 2017/10/8.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "ViewController.h"
#import "RACBasicUseController.h"
#import "LoginViewController.h"
#import "RACNetworkData.h"
#import "RACOtherViewController.h"
#import "RACAdvanceViewController.h"
#import "RACOperationViewController.h"

@interface ViewController ()

@end

@implementation ViewController 
- (IBAction)oneBasicUse:(id)sender {
    RACBasicUseController *basicVC = [RACBasicUseController new];
    [self.navigationController pushViewController:basicVC animated:YES];
}

// 2.模拟登录界面
- (IBAction)twoLogin:(id)sender {
    LoginViewController *loginVC = [LoginViewController new];
    [self.navigationController pushViewController:loginVC animated:YES];
}

// 3.处理网络请求
- (IBAction)threeNetwork:(id)sender {
    RACNetworkData *networkVC = [RACNetworkData new];
    [self.navigationController pushViewController:networkVC animated:YES];
}

// 4.其他一些常见的信号类
- (IBAction)fourOtherClass:(id)sender {
    RACOtherViewController *otherVC = [RACOtherViewController new];
    otherVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:otherVC animated:YES];
}

// 5.RAC的一些高级用法
- (IBAction)fiveAdvanceUsage:(id)sender {
    RACAdvanceViewController *advanceVC = [RACAdvanceViewController new];
    advanceVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:advanceVC animated:YES];
}

// 6.RAC的一些操作方法
- (IBAction)sixOperationMethod:(id)sender {
    
    RACOperationViewController *operationVC = [RACOperationViewController new];
    operationVC.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:operationVC animated:YES];
}


@end
