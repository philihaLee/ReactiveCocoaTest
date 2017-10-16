//
//  RACView.m
//  Login
//
//  Created by philia on 2017/10/14.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "RACView.h"

@implementation RACView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    _buttonSignal = [RACSubject subject];
    
    [self setupUI];
    return self;
}

- (void)setupUI {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setTitle:@"点击" forState:UIControlStateNormal];
    [button sizeToFit];
    [self addSubview:button];
    
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.offset(0);
    }];
    
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [_buttonSignal sendNext:@"red"];
    }];
}

@end
