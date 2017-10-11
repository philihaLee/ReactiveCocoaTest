//
//  RACNetworkData.m
//  Login
//
//  Created by philia on 2017/10/8.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "RACNetworkData.h"
#import "NetworkDataViewModel.h"

@interface RACNetworkData ()

@property (nonatomic, strong) NetworkDataViewModel *networkDataVM;

@end

@implementation RACNetworkData

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"模拟登录界面";
    
    _networkDataVM = [NetworkDataViewModel new];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self getRequest];
}

- (void)getRequest {
    
    [[self.networkDataVM.requestCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        
        NSLog(@"%@---%@---%@", [[x firstObject] city], [[x firstObject] cityid], [[x firstObject] njd]);
    }];;
    
}



@end
