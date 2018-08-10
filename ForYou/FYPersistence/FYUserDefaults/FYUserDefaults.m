//
//  FYUserDefaults.m
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYUserDefaults.h"
#import "FYFoundationCategory.h"

@interface FYUserDefaults()
@property (nonatomic, strong) NSUserDefaults *userDefaults;
@end

@implementation FYUserDefaults

#define kAccessToken @"kAccessToken"
#define kShowComeInVersion @"kShowComeInVersion"
#define kFYUser @"kFYUser"

#pragma mark - life cycle
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FYUserDefaults *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[FYUserDefaults alloc] init];
    });
    return instance;
}

#pragma mark - getters and setters

- (void)saveUser:(FYUser *)user {
    [self.userDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:user] forKey:kFYUser];
    [self.userDefaults synchronize];
}

- (FYUser *)user {
    return [NSKeyedUnarchiver unarchiveObjectWithData:[self.userDefaults objectForKey:kFYUser]];
}

- (NSUserDefaults *)userDefaults {
    if (_userDefaults == nil) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
    }
    return _userDefaults;
}

- (void)saveAccessToken:(NSString *)accessToken {
    [self.userDefaults setObject:accessToken forKey:kAccessToken];
    [self.userDefaults synchronize];
}

- (NSString *)accessToken {
    return [self.userDefaults objectForKey:kAccessToken];
}

- (void)setShowComeInVersion:(NSString *)showComeInVersion {
    [self.userDefaults setObject:showComeInVersion forKey:kShowComeInVersion];
    [self.userDefaults synchronize];
}

- (NSString *)showComeInVersion {
    return [self.userDefaults objectForKey:kShowComeInVersion];
}

@end
