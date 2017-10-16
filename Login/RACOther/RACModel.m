//
//  RACModel.m
//  Login
//
//  Created by philia on 2017/10/14.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "RACModel.h"

@implementation RACModel

+ (instancetype)modelWithDictionary:(NSDictionary *)dict {
    id instance = [[self alloc] init];
    [instance setValuesForKeysWithDictionary:dict];
    return instance;
}

- (NSString *)description {
    NSArray *keys = @[@"hehe1", @"hehe2", @"hehe3", @"hehe4"];
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
