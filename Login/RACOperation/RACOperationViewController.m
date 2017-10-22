//
//  RACOperationViewController.m
//  Login
//
//  Created by philia on 2017/10/22.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "RACOperationViewController.h"
#import <ReactiveObjC/RACReturnSignal.h>

@interface RACOperationViewController ()

@end

@implementation RACOperationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self demo1];
//    [self demo2];
//    [self demo3];
    [self demo4];
}

#pragma mark - 绑定
- (void)demo1 {
    
    RACSubject *subject = [RACSubject subject];
    RACSignal *bindSignal = [subject bind:^RACSignalBindBlock _Nonnull{
        return ^RACSignal *(id value, BOOL *stop) {
          
            // 接收到源信号的内容
            NSLog(@"value: %@", value);
            
            // 内容处理
            value = [NSString stringWithFormat:@"嗯哼: %@", value];
            
            return [RACReturnSignal return:value];
        };
    }];
    
    [bindSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    // 发送数据
    [subject sendNext:@"呵呵😑"];
}

#pragma mark - 映射
- (void)demo2 {
    
    // TODO: 1.flattenMap
//    RACSubject *subject = [RACSubject subject];
//    RACSignal *mapSignal = [subject flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
//        // 返回的信号就是需要去包装的值  value就是信号发送的内容
//        // 返回信号用来包装修改内容的值
//
//        value = [NSString stringWithFormat:@"%@, 去洗吧", value];
//
//        return [RACReturnSignal return:value];
//    }];
//
//    [mapSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
//
//    // 发送数据
//    [subject sendNext:@"呵呵,想去洗澡"];
    
    //flattenMap一般用于SignalOfSignals
//    RACSubject *signalOfsignals = [RACSubject subject];
//    RACSubject *signal = [RACSubject subject];
//
//    [signalOfsignals subscribeNext:^(RACSignal *  _Nullable x) {
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"%@1", x);
//        }];
//    }];
//
//    [signalOfsignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@2", x);
//    }];
//
//    [[signalOfsignals flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
//        // 这个value是信号中的信号
//        return value;
//    }] subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@3", x);
//    }];
//
//    [signalOfsignals sendNext:signal];
//    [signal sendNext:@"呵呵"];
    
    
    
    // TODO: 2.Map
//    RACSubject *subject = [RACSubject subject];
//    RACSignal *mapSignal = [subject map:^id _Nullable(id  _Nullable value) {
//        return [NSString stringWithFormat:@"%@😑", value];
//    }];
//
//    [mapSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
//
//    [subject sendNext:@"呵呵1"];
//    [subject sendNext:@"呵呵2"];
//    [subject sendNext:@"呵呵3"];
}


#pragma mark - 组合
- (void)demo3 {
    
    
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"呵呵1"];
        // 发送完成
        [subscriber sendCompleted];
        return nil;
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"呵呵2"];
        // 发送完成
        [subscriber sendCompleted];
        return nil;
    }];
    
    // TODO: 1.concat
    // 信号组合<第一个信号必须发送completed>
//    RACSignal *concatSignal = [signal1 concat: signal2];
//    [concatSignal subscribeNext:^(id  _Nullable x) {
//        // 必须先signal1 再 signal2
//        NSLog(@"%@", x);
//    }];
    
    // TODO: 2.then -> 忽略掉第一个信号所有值<同样发送completed>
//    RACSignal *thenSignal = [signal1 then:^RACSignal * _Nonnull{
//        return signal2;
//    }];
//
//    [thenSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"%@", x);
//    }];
    
    
    // TODO: 3.merge  -->> 合并信号
//    RACSignal *mergeSignal = [signal1 merge:signal2];
//    [mergeSignal subscribeNext:^(id  _Nullable x) {
//        // 任何一个信号发送内容都会来到这个block
//        NSLog(@"%@", x);
//    }];
    
    // TODO: 4.把两个信号压缩成一个信号 -- > 压缩成一个元组<两个信号同时发送内容>
//    RACSignal *zipSignal = [signal1 zipWith:signal2];
//    [zipSignal subscribeNext:^(id  _Nullable x) {
//        // 等所有信号都发送内容完毕后才会执行这个block
//        NSLog(@"%@", x);
//    }];
    
    // TODO: 5.combineLasts  组合  reduce 聚合<详情见登录界面>
    RACSignal *combineSignal = [RACSignal combineLatest:@[signal1, signal2] reduce:^id _Nullable(NSString *str1, NSString *str2){
        
        return [NSString stringWithFormat:@"%@😑%@", str1, str2];
    }];
    
    [combineSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
}

#pragma mark - 过滤
- (void)demo4 {
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [subscriber sendNext:@"呵呵1"];
        [subscriber sendNext:@"呵呵3"];
        // 发送完成
        [subscriber sendCompleted];
        return nil;
    }];    
    
    // TODO: - 1.过滤
    [[signal1 filter:^BOOL(id  _Nullable value) {
        return [value hasPrefix:@"呵"];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"只有满足上面的条件才能拿到----%@----哦", x);
    }];
    
    // TODO: - 2.忽略一些值
    RACSignal *signal = [signal1 ignore:@"呵呵1"];
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
}


@end
