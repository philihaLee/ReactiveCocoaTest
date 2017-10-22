//
//  RACAdvanceViewController.m
//  Login
//
//  Created by philia on 2017/10/14.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "RACAdvanceViewController.h"

@interface RACAdvanceViewController ()

@property (nonatomic, strong) RACSignal *signal;

@end

@implementation RACAdvanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self demo1];
//    [self demo2];
//    [self demo3];
    [self demo4];
}

#pragma mark - liftSelector全部信号收到之后执行方法
- (void)demo1 {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    // 信号1
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        [manager GET:@"http://www.weather.com.cn/data/sk/101010100.html" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [subscriber sendNext:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [subscriber sendError:error];
        }];
        
        return nil;
    }];
    // 信号2
    
    RACSignal *signal2 = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [manager GET:@"http://www.weather.com.cn/data/sk/101010100.html" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [subscriber sendNext:responseObject];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [subscriber sendError:error];
            }];
        });
        
        return nil;
    }];
    
    [self rac_liftSelector:@selector(setupUI:data2:) withSignalsFromArray:@[signal1, signal2]];
}

/// 方法的参数必须和信号的数量一致
- (void)setupUI:(id)data1 data2:(id)data2 {
    NSLog(@"更新UI");
}

#pragma mark - RAC常见的宏
/// 常见的宏
- (void)demo2 {
    UILabel *label = [UILabel new];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.offset(0);
        make.top.offset(100);
    }];
    
    
    UITextField *textField = [UITextField new];
    textField.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:textField];
    
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(50);
        make.top.offset(200);
        make.right.offset(-50);
    }];
    
    // 信号发生改变向属性赋值
    RAC(label, text) = textField.rac_textSignal;
    
    // 对某个属性进行监听, 类似KVO
    [RACObserve(label, text) subscribeNext:^(id  _Nullable x) {
        NSLog(@"label的值改变了");
    }];
    
    // 由于信号会一直存在, 所以RAC的block里面一旦出现self百分之百会出现循环引用,所以下面这两对强大的宏用来解除循环引用<外层用weak 内层用strong>
    @weakify(self);
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self);
        NSLog(@"%@", self);
        return nil;
    }];
    
    _signal = signal;
    
    // 包装元组
    RACTuple *tuple = RACTuplePack(@"呵呵", @1);
    NSLog(@"%@", tuple);
    
    // 解析元组
    RACTupleUnpack(id value1, id value2) = tuple;;
    NSLog(@"%@----%@", value1, value2);
}


#pragma mark - RACMulticastConnection多点传播的类
/// RACMulticastConnection<使用信号创建这个类>
- (void)demo3 {
    
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        // 只想发送一次请求
        NSLog(@"发送请求");
        
        [subscriber sendNext:@"呵呵😑"];
        return nil;
    }];
    
    /// 转换
//    RACMulticastConnection *connection = signal.publish;
    /// 或者这么写<可以先发送数据再进行订阅>
     RACMulticastConnection *connection1 = [signal multicast:[RACReplaySubject subject]];
    
    
    [connection1.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@----订阅者1", x);
    }];
    
    [connection1.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@----订阅者2", x);
    }];
    
    // 连接
    [connection1 connect];
}


#pragma mark - RACCommand事件处理
/// RACCommand: 方便的监控事件的执行
- (void)demo4 {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        NSLog(@"这里打印神马东西啊❓ %@", input);
        
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            // 发送数据
            [subscriber sendNext:@"执行命令产生了信号"];
            
            // 发送完成
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    
    
    // 执行
//    RACSignal *signal = [command execute:@"呵呵"];
    // TODO: - 第一种方式
//    // 订阅
//    [signal subscribeNext:^(id  _Nullable x) {
//        // 之前发送的数据
//        NSLog(@"%@", x);
//    }];
    
    // TODO: - 第二种方式拿到数据 signalOfSignals
//    [command.executionSignals subscribeNext:^(RACSignal *  _Nullable x) {
//        [x subscribeNext:^(id  _Nullable x) {
//            NSLog(@"%@", x);
//        }];
//    }];
    
    // TODO: - 第三种方法: 获取最新发送的信号(获取signalOfSignals)
    [command.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    [command execute:@"呵呵1"];
    
    // 监听事件有没有完成
    [command.executing subscribeNext:^(NSNumber * _Nullable x) {
        if (x.boolValue) {
            NSLog(@"表示当前正在执行");
        } else {
            NSLog(@"没有执行或者执行完成");
        }
    }];
}

@end
