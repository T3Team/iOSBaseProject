//
//  FYAppContext.m
//  ForYou
//
//  Created by marcus on 2017/8/2.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYAppContext.h"
#import "FYHeader.h"

@interface FYAppContext()

@property (nonatomic, strong) UIDevice *device;
@property (nonatomic, copy, readwrite) NSString *net;

@property (nonatomic, copy, readwrite) NSString *model;              //设备名称
@property (nonatomic, copy, readwrite) NSString *os;                 //系统名称
@property (nonatomic, copy, readwrite) NSString *osVersion;          //系统版本
@property (nonatomic, copy, readwrite) NSString *appVersion;         //Bundle版本
@end

@implementation FYAppContext

#pragma mark - public methods
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FYAppContext *sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[FYAppContext alloc] init];
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    });
    return sharedInstance;
}

#pragma mark - getters and setters
- (UIDevice *)device
{
    if (_device == nil) {
        _device = [UIDevice currentDevice];
    }
    return _device;
}

- (NSString *)model
{
    if (_model == nil) {
        _model = [self.device.modelName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return _model;
}

- (NSString *)os
{
    if (_os == nil) {
        _os = [self.device.systemName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    return _os;
}

- (NSString *)osVersion
{
    if (_osVersion == nil) {
        _osVersion = [self.device systemVersion];
    }
    return _osVersion;
}

- (NSString *)appVersion
{
    if (_appVersion == nil) {
        _appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    }
    return _appVersion;
}

- (BOOL)isReachable
{
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusUnknown) {
        return YES;
    } else {
        return [[AFNetworkReachabilityManager sharedManager] isReachable];
    }
}

- (NSString *)net
{
    if (_net == nil) {
        _net = @"无网络";
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWWAN) {
            _net = @"2G3G4G";
        }
        if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            _net = @"WiFi";
        }
    }
    return _net;
}

+ (BOOL)isHighWithVersion:(NSString *)version newVersion:(NSString *)newVersion {
    NSArray *localArray = [version componentsSeparatedByString:@"."];
    NSArray *appArray = [newVersion componentsSeparatedByString:@"."];
    NSInteger minArrayLength = MIN(localArray.count, appArray.count);
    for(int i=0;i<minArrayLength;i++){//以最短的数组长度为遍历次数,防止数组越界
        NSString *localElement = localArray[i];
        NSString *appElement = appArray[i];
        NSInteger  localValue =  localElement.integerValue;
        NSInteger  appValue = appElement.integerValue;
        if(localValue<appValue) {
            return YES;
        }else if(localValue>appValue) {
            return NO;
        }
    }
    if (appArray.count>localArray.count) { //数组长度相等的数据相同，并且newVersion长 说明需要更新
        return YES;
    }else {
        return NO;
    }
}

@end
