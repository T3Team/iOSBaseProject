//
//  FYUserDefaults.h
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//  NSUserDefaults管理类

#import <Foundation/Foundation.h>
#import "FYUser.h"

@interface FYUserDefaults : NSObject

/**
 FYUserDefaults单例
 
 @return FYUserDefaults单例
 */
+ (instancetype )sharedInstance;

//保存、获取用户信息
- (void)saveUser:(FYUser *)user;
- (FYUser *)user;

- (void)saveAccessToken:(NSString *)accessToken;
- (NSString *)accessToken;

- (void)setShowComeInVersion:(NSString *)showComeInVersion;
- (NSString *)showComeInVersion;

@end
