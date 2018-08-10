//
//  FYDictionaryManager.m
//  ForYou
//
//  Created by marcus on 2017/8/23.
//  Copyright © 2017年 ForYou. All rights reserved.
//   全局字典管理 单例

#import "FYDictionaryManager.h"
#import "FYPlistManager.h"

@interface FYDictionaryManager()
//所有的字典数据 最新数据
@property (nonatomic, strong) NSDictionary *allDictionaryNew;
//所有的字典数据 本地数据
@property (nonatomic, strong) NSDictionary *allDictionaryLocation;
//单例数据字典中 title对应Array  不是全量的需要的自己添加
@property (nonatomic, strong) NSDictionary *titleDictionary;
@property (nonatomic, strong) NSArray *nationalityData;
@property (nonatomic, strong) NSArray *educationData;

@end

//打包时Plist文件名
NSString * const kFYDictionaryInfoManager = @"FYDictionaryInfoManager";
//更新保存的Plist文件名  优先取更新保存的Plist
NSString * const kFYDictionaryInfoManagerNew = @"FYDictionaryInfoManagerNew";

@implementation FYDictionaryManager

#pragma mark - life cycle
- (instancetype)init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - public methods
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static FYDictionaryManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[FYDictionaryManager alloc] init];
        instance.allDictionaryLocation = [FYPlistManager loadDataWithFileName:kFYDictionaryInfoManager];
        instance.allDictionaryNew = [FYPlistManager loadDataWithFileName:kFYDictionaryInfoManagerNew];
    });
    return instance;
}

- (void)updateData {
//[FYPlistManager saveData:weakSelf.allDictionaryNew withFileName:kFYDictionaryInfoManagerNew];
}

+ (NSString *)nameWithValue:(NSNumber *)value data:(NSArray *)data {
    NSString *result = nil;
    if ([value isKindOfClass:[NSNumber class]]) {
        for (NSDictionary *sellPriceDic in data) {
            if ([sellPriceDic[@"value"] integerValue] == [value integerValue]) {
                return result = [sellPriceDic[@"name"] copy];
            }
        }
    }
    return result;
}

+ (NSNumber *)valueWithName:(NSString *)name data:(NSArray *)data {
    NSNumber *result = nil;
    
    for (NSDictionary *sellPriceDic in data) {
        if ([sellPriceDic[@"name"] isEqualToString:name]) {
            return result = [sellPriceDic[@"value"] copy];
        }
    }
    
    return result;
}

- (NSArray *)nationalityList {
    return self.nationalityData;
}

- (NSArray *)educationList {
    return self.educationData;
}

#pragma mark - private
- (id)loadDataWithPlistName:(NSString *)plistName {
    if ([FYPlistManager isExistWithFileNameInLibrary:plistName]) {
        return [FYPlistManager loadDataWithFileName:plistName];
    }
    return nil;
}


- (NSArray *)loadDataForKey:(NSString *)key {
    NSArray *array = nil;
    if (self.allDictionaryNew) {
        array = [self.allDictionaryNew objectForKey:key];
    }
    
    if (!array || array.count == 0) {
        array = [self.allDictionaryLocation objectForKey:key];
    }
    
    return array;
}

//国籍
- (NSArray *)nationalityData {
    if (!_nationalityData) {
        _nationalityData = [NSArray arrayWithArray:[self loadDataForKey:@"App通用Ұ国籍"]];
    }
    return _nationalityData;
}

//学历
- (NSArray *)educationData {
    if (!_educationData) {
        _educationData = [NSArray arrayWithArray:[self loadDataForKey:@"App通用Ұ学历"]];
    }
    return _educationData;
}

- (NSArray *)arrayWithTitle:(NSString *)title {
    NSArray *array = [self.titleDictionary objectForKey:title]?:@[];
    return array;
}

@end
