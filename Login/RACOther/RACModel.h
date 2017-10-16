//
//  RACModel.h
//  Login
//
//  Created by philia on 2017/10/14.
//  Copyright © 2017年 philia. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RACModel : NSObject

@property (nonatomic, copy) NSString *hehe1;
@property (nonatomic, copy) NSString *hehe2;
@property (nonatomic, copy) NSString *hehe3;
@property (nonatomic, copy) NSString *hehe4;

+ (instancetype)modelWithDictionary:(NSDictionary *)dict;

@end
