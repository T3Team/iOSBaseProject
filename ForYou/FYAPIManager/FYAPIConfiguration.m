//
//  FYAPIConfiguration.m
//  ForYou
//
//  Created by marcus on 2017/7/28.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYAPIConfiguration.h"

@implementation FYAPIConfiguration

+ (instancetype)currentConfiguration {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = self.new;
    });
    return instance;
}


- (instancetype)init {
    if (self = [super init]) {
        //默认地址配置
        _baseUrl = @"https://baidu.com";
        _h5Url = @"https://baidu.com";
    }
    return self;
}

@end
