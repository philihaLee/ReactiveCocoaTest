//
//  NetworkDataModel.m
//  Login
//
//  Created by philia on 2017/10/8.
//  Copyright © 2017年 philia. All rights reserved.
//

#import "NetworkDataModel.h"

@implementation NetworkDataModel

- (NSString *)description {
    NSArray *keys = @[@"Radar", @"SD", @"WD", @"WS"];
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
