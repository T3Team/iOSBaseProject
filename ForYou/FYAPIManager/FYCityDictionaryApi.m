//
//  FYCityDictionaryApi.m
//  FangYou
//
//  Created by marcus on 2018/3/19.
//  Copyright © 2018年 FangYou. All rights reserved.
//

#import "FYCityDictionaryApi.h"

@implementation FYCityDictionaryApi{
    NSString *_etag;
}

- (instancetype)initWithEtag:(NSString *)etag {
    self = [super init];
    if (self) {
        _etag = etag;
    }
    return self;
}

- (NSString *)requestUrl {
    NSString *result;
    NSString *cityID = [FYUserDefaults sharedInstance].cityID?:@"";
    if (![NSString isEmpty:_etag]) {
        result = [NSString stringWithFormat:@"data-dict/rms/keys/%@?etag=%@&client=1",cityID,_etag];
    }else {
        result = [NSString stringWithFormat:@"data-dict/rms/keys/%@?client=1",cityID];
    }
    return result;
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

- (id)requestArgument {
    return @{};
}

@end
