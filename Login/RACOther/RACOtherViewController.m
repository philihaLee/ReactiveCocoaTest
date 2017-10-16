//
//  RACOtherViewController.m
//  Login
//
//  Created by philia on 2017/10/14.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "RACOtherViewController.h"
#import "RACView.h"
#import "RACModel.h"

@interface RACOtherViewController ()

@property (nonatomic, strong) id<RACSubscriber> subscribe;

@end

@implementation RACOtherViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self demo1];
//    [self demo2];
//    [self demo3];
//    [self RACReplaySubject];
//    [self demo4];
    [self demo5];
}

#pragma mark - RACDisposable
/// RACDisposable
- (void)demo1 {
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [subscriber sendNext:@"发送信息"];
        _subscribe = subscriber;
        
        return [RACDisposable disposableWithBlock:^{
            // 信号取消会来到这个block, 用来清空资源
            NSLog(@"信号订阅被取消了");
        }];
    }];
    
    RACDisposable *disposable = [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [disposable dispose];
    });
}

#pragma mark - RACSubject<主要用来代替代理>
/// RACSubject: 仅仅保存订阅者,然后就return<而RACSignal订阅后执行block>
- (void)demo2 {
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者一:  接收到的数据: %@", x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者二:  接收到的数据: %@", x);
    }];
    [subject sendNext:@"呵呵🙄"];//遍历所有订阅者发送数据
}

#pragma mark - RACReplaySubject
/// 代替代理
- (void)demo3 {
    RACView *view = [[RACView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
  
    [view.buttonSignal subscribeNext:^(id  _Nullable x) {
        if ([[x description] isEqualToString:@"red"]) {
            view.backgroundColor = [UIColor redColor];
        }
    }];
}

/// RACReplaySubject :先发送数据, 再订阅信号
- (void)RACReplaySubject {
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 1.保存值  2.调用super sendNext
    [replaySubject sendNext:@"呵呵😑"];
    
    [replaySubject subscribeNext:^(id  _Nullable x) {
        // 遍历所有的值, 拿到订阅者去发送数据
        NSLog(@"订阅之前发送的数据: %@", x);
    }];
    
}

#pragma mark - RACTuple, RACSequence
/// RACTuple元组类
- (void)demo4 {
    RACTuple *tuple = [RACTuple tupleWithObjects:@"呵呵", @1, nil];
    for (id obj in tuple) {
        NSLog(@"value:%@, class:%@", obj, [obj class]);
    }
}

/// RACSequence集合类: 可以用于字典转模型
- (void)demo5 {
    NSArray *array = @[@"呵呵1", @"呵呵2", @"😑", @1];
    RACSequence *sequence = array.rac_sequence;
    RACSignal *signal = sequence.signal;
    
    [signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"value:%@-----class:%@", x, [x class]);
    }];
    
    NSDictionary *dictionary = @{@"hehe1":@"你", @"hehe2": @"是个", @"hehe3": @"好人", @"hehe4": @88};
    [dictionary.rac_sequence.signal subscribeNext:^(RACTuple *x) {
        // 等号右边放需要解析的元组, 左边放变量名
        RACTupleUnpack(NSString *key, id value) = x;
        NSLog(@"key:%@, value:%@", key, value);
    }];
    
    // 字典转模型1
    NSMutableArray *arrM = [NSMutableArray array];
    NSArray *arr = @[dictionary];
    [arr.rac_sequence.signal subscribeNext:^(NSDictionary *  _Nullable x) {
        RACModel *model = [RACModel modelWithDictionary:x];
        [arrM addObject:model];
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@", arrM.copy);
    });
    
    // 字典转模型2:映射
    NSArray *resuleArray = [arr.rac_sequence map:^id _Nullable(id  _Nullable value) {
        return [RACModel modelWithDictionary:value];
    }].array;
    
    NSLog(@"%@", resuleArray);
}

@end
