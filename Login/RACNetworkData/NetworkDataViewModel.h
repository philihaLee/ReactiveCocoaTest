//
//  NetworkDataViewModel.h
//  Login
//
//  Created by philia on 2017/10/8.
//  Copyright © 2017年 philia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NetworkDataModel.h"

@interface NetworkDataViewModel : NSObject

@property (nonatomic, strong, readonly) RACCommand *requestCommand;

@property (nonatomic, strong) NSArray<NetworkDataModel *> *modelArray;

@end
