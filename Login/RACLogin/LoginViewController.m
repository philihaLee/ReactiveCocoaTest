//
//  LoginViewController.m
//  Login
//
//  Created by philia on 2017/10/8.
//  Copyright © 2017年 philia. All rights reserved.
//  

#import "LoginViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()

@property (nonatomic, strong) LoginViewModel *loginVM;

@end

@implementation LoginViewController {
    UITextField *_textField1;
    UITextField *_textField2;
    UIButton *_button;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"模拟登录界面";
    
    [self setupUI];
    
    [self bindViewModel];
    
    [self dealEvent];
}

/// 绑定
- (void)bindViewModel {
    _loginVM = [LoginViewModel new];
    
    RAC(self.loginVM, text1) = _textField1.rac_textSignal;
    RAC(self.loginVM, text2) = _textField2.rac_textSignal;
    
    RAC(_button, enabled) = self.loginVM.loginSignal;
}

/// 处理事件
- (void)dealEvent {
    // 监听按钮点击
    [[_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        NSLog(@"1.点击登录按钮");
        // 处理登录事件
        [self.loginVM.loginCommand execute:nil];
    }];
}

- (void)setupUI {
    _textField1 = [[UITextField alloc] init];
    _textField2 = [[UITextField alloc] init];
    _textField1.backgroundColor = [UIColor lightGrayColor];
    _textField2.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_textField1];
    [self.view addSubview:_textField2];
    
    [_textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-100);
        make.width.offset(200);
    }];
    [_textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(-50);
        make.width.offset(200);
    }];
    
    _button = [UIButton buttonWithType:UIButtonTypeSystem];
    [_button setTitle:@"登录" forState:UIControlStateNormal];
    _button.enabled = NO;
    [self.view addSubview:_button];
    
    [_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.centerY.offset(0);
    }];
}


@end
