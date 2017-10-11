//
//  LoginViewModel.h
//  Login
//
//  Created by philia on 2017/10/8.
//  Copyright © 2017年 philia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (nonatomic, copy) NSString *text1;
@property (nonatomic, copy) NSString *text2;

@property (nonatomic, strong) RACSignal *loginSignal;
@property (nonatomic, strong, readonly) RACCommand *loginCommand;


@end
