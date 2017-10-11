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





@end
