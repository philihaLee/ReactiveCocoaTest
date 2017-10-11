//
//  LoginViewModel.m
//  Login
//
//  Created by philia on 2017/10/8.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self dealLogin];
    
    return self;
}

- (void)dealLogin {
    // TODO: 1.按钮是否能够点击
    _loginSignal = [RACSignal combineLatest:@[RACObserve(self, text1), RACObserve(self, text2)] reduce:^id _Nullable (NSString *text1, NSString *text2){
        NSLog(@"账号:%@----密码:%@", text1, text2);
        return @(text1.length && text2.length);
    }];
    
    // TODO: 2.登录命令
    _loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"2.向服务器发送登录请求");
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            // 发送数据
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [subscriber sendNext:@"3.发送数据"];
                [subscriber sendCompleted];
            });
            return nil;
        }];
    }];
    
    // 获取信号源
    [_loginCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    // 监听命令的执行
    [[_loginCommand.executing skip:1] subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue) {
            NSLog(@"正在执行");
            [SVProgressHUD showWithStatus:@"正在登录"];
        } else {
            NSLog(@"执行完成");
            [SVProgressHUD showSuccessWithStatus:@"登录成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
            });
        }
    }];
    
}

@end
