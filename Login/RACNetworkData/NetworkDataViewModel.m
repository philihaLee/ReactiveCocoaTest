//
//  NetworkDataViewModel.m
//  Login
//
//  Created by philia on 2017/10/8.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "NetworkDataViewModel.h"


@implementation NetworkDataViewModel

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    [self loadData];
    
    return self;
}

- (void)loadData {
    _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            NSString *urlStr = @"http://www.weather.com.cn/data/sk/101010100.html";
            AFHTTPSessionManager *manager = AFHTTPSessionManager.manager;
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
            
            [manager GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                // 在这里发送数据
                NSDictionary *dictionary = responseObject[@"weatherinfo"];
                // 字典转模型
                NSArray *arr = @[dictionary];
                self.modelArray = [arr.rac_sequence map:^id _Nullable(id  _Nullable value) {
                    return [NetworkDataModel yy_modelWithDictionary:value];
                }].array;
                
                [subscriber sendNext:self.modelArray];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@", error);
            }];
            
            return nil;
        }];
        
        return signal;
    }];
}

@end
