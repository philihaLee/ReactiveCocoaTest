//
//  RACBasicUse.m
//  Login
//
//  Created by philia on 2017/10/8.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "RACBasicUseController.h"

static NSString * const cellID = @"cellID";
static NSString * const MyButtonClickNotification = @"MyButtonClickNotification";

@interface RACBasicUseController() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, assign) NSInteger number;

@end
@implementation RACBasicUseController

#pragma mark - 1.代替addTarget
/// 1.代替addTarget
- (void)demo1 {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"代替addTarget" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(80);
    }];
    
    /// ControlEvent自定义
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        NSLog(@"按钮被点击了:%@", x);
    }];
}

#pragma mark - 2.代替代理
/// 2.代替代理(有返回值的代理方法无法执行)
- (void)demo2 {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellID];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.offset(0);
        make.height.offset(300);
    }];
    
    UILabel *label = [UILabel new];
    label.text = @"    代替代理";
    [label sizeToFit];
    tableView.tableHeaderView = label;
    
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        // x表示代理方法的两个参数<用RAC的元组表示>
        NSLog(@"%@", x);
        
        NSIndexPath *indexPath = x.last;
        NSLog(@"选中了第%zd行", indexPath.row + 1);
    }];;
    tableView.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    cell.textLabel.text = @(indexPath.row + 1).description;
    return cell;
}


#pragma mark - 3.代替通知
/// 3.代替通知
- (void)deme3 {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"代替通知" forState:UIControlStateNormal];
    [self.view addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(150);
    }];
    
    /// RAC代替通知
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:MyButtonClickNotification object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        NSLog(@"%@", x);
        
        NSLog(@"我是按钮点击发送的通知");
    }];
    
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[NSNotificationCenter defaultCenter] postNotificationName:MyButtonClickNotification object:x];
    }];
}

#pragma mark - 4.代替KVO
/// 4.代替KVO
- (void)demo4 {
    [[self rac_valuesForKeyPath:@"number" observer:self] subscribeNext:^(id  _Nullable x) {
        NSLog(@"%@", x);
    }];
    
    UIButton *numberButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [numberButton setTitle:@"0" forState:UIControlStateNormal];;
    numberButton.titleLabel.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:numberButton];
    
    [numberButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(200);
    }];
    
    [[numberButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        self.number++;
    }];;
    
    [RACObserve(self, self.number) subscribeNext:^(id  _Nullable x) {
        [numberButton setTitle:[x description] forState:UIControlStateNormal];
    }];
    
    [self rac_observeKeyPath:@"number" options:NSKeyValueObservingOptionNew observer:nil block:^(id value, NSDictionary *change, BOOL causedByDealloc, BOOL affectedOnlyLastComponent) {
        NSLog(@"代替KVO第二种方式,数字改变了");
    }];
    
    [[self rac_valuesForKeyPath:@"number" observer:nil] subscribeNext:^(id  _Nullable x) {
        NSLog(@"代替KVO的第三种方式");
    }];
}


#pragma mark - 代替手势
/// 5.代替手势
- (void)demo5 {
    UILabel *label = [UILabel new];
    label.text = @"RAC代替手势";
    label.font = [UIFont systemFontOfSize:30];
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(280);
    }];
    label.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [UITapGestureRecognizer new];
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"轻敲Label");
    }];
    [label addGestureRecognizer:tap];
}


#pragma mark - 监听方法是否调用
/// 监听方法<可以代替代理, 个人不建议使用, 还是使用信号比较好>
- (void)demo6 {
    [[self rac_signalForSelector:@selector(didReceiveMemoryWarning)] subscribeNext:^(RACTuple * _Nullable x) {
        NSLog(@"didReceiveMemoryWarning方法被调用了");
    }];
}


#pragma mark - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"RAC的基本使用";
    
    [self demo1];
    [self demo2];
    [self deme3];
    [self demo4];
    [self demo5];
    [self demo6];
}

@end
