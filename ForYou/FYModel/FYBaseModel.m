//
//  FYBaseModel.m
//  ForYou
//
//  Created by marcus on 2017/8/2.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYBaseModel.h"

@implementation FYBaseModel

- (id)copyWithZone:(nullable NSZone *)zone {
     FYBaseModel *baseModel = [[FYBaseModel allocWithZone:zone] init];
    return baseModel;
}

@end
