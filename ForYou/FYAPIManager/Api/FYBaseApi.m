//
//  FYBaseApi.m
//  ForYou
//
//  Created by marcus on 2017/9/12.
//  Copyright © 2017年 ForYou. All rights reserved.
//
#import "FYBaseApi.h"
#import "NSString+FYCategory.h"

//DEBUG 时，打印出相应请求数据
#ifdef DEBUG
#define FYRequestLog(__result_,__ViewControllerName_, __Url_, __Type_, __Params_, __ResponseData_) \
fprintf(stderr, "\n\n======== 数据请求%s(%s): ========\n",__result_.UTF8String,__ViewControllerName_.UTF8String); \
fprintf(stderr, "-- RequestUrl: %s\n", __Url_.UTF8String); \
fprintf(stderr, "-- Type: %s\n", __Type_.UTF8String); \
if (__Params_) {\
fprintf(stderr, "-- Params: %s\n", [NSString stringWithFormat:@"%@", __Params_].UTF8String); \
} \
if (__ResponseData_) {\
fprintf(stderr, "-- ResponseData: %s\n", [NSString stringWithFormat:@"%@", __ResponseData_].UTF8String); \
}\
fprintf(stderr, "================================================\n\n");
#else
#define FYRequestLog(__result_,__ViewControllerName_, __Url_, __Type_, __Params_, __ResponseData_)
#endif

@implementation FYBaseApi
@synthesize headerFields = _headerFields;

- (void)dealloc{
    [self cancel];
}

- (instancetype)init{
    if (self = [super init]) {
        _needsTokenHeaderField = YES;
    }
    return self;
}

- (NSDictionary<NSString *,NSString *> *)requestHeaderFieldValueDictionary{
    NSMutableDictionary <NSString *,NSString *> *headerParameters = self.headerFields.mutableCopy;
    if (self.needsTokenHeaderField) {
        NSString *token = [FYUserDefaults sharedInstance].accessToken;
        token = (!token ? @"" : token);
        headerParameters[@"Authorization"] = token;
    }
    //增加api 版本信息
    NSString *version = [self apiVersion];
    version = [NSString isEmpty:version]?@"application/vnd.ForYou.v1+json":version;
    headerParameters[@"produces"] = version;
    return headerParameters;
}

- (NSDictionary<NSString *,NSString *> *)headerFields{
    if (nil == _headerFields) {
        _headerFields =  @{
                          @"x-ForYou-app-id":@"8888",
                          @"x-ForYou-access-token":@"",
                          @"x-ForYou-app-sign":@"",
                          @"Accept": @"application/vnd.ForYou.v1+json",
                          @"Content-Type":@"application/json",
                          @"x-fy-device-name": [UIDevice currentDevice].modelName?:@"",
                          @"x-fy-device-unique-key":[UIDevice currentDevice].deviceID?:@""
                        };
    }
    return _headerFields;
}

- (YTKRequestSerializerType)requestSerializerType{
    return YTKRequestSerializerTypeJSON;
}

- (NSString *)baseUrl{
    return [FYAPIConfiguration currentConfiguration].baseUrl;
}

- (void)cancel{
    [self.requestTask cancel];
    [self clearCompletionBlock];
}

- (NSTimeInterval)requestTimeoutInterval {
    return kFYNetworkingTimeoutSeconds;
}


#pragma mark --parameter
- (NSDictionary *)queryParameter{
    return nil;
}

- (NSString *)requestUrlToBeAddQueryParameter{
    return nil;
}

#pragma mark --override
//子类没有实现requestUrl，自动添加query参数逻辑
- (NSString *)requestUrl{
    NSString *originUrl = [self requestUrlToBeAddQueryParameter];
    return [self urlPathByAppendQueryParameterToUrlPath:originUrl];
}

#pragma mark --private
- (NSString *)urlPathByAppendQueryParameterToUrlPath:(NSString *)urlPath{
    NSDictionary *para = [self queryParameter];
    if (!urlPath || !para) {
        return nil;
    }
    //
    NSMutableString *urlWithQuery = [NSMutableString stringWithString:urlPath];
    [para.allKeys enumerateObjectsUsingBlock:^(id  _Nonnull key, NSUInteger idx, BOOL * _Nonnull stop) {
        if (0 == idx) {
            [urlWithQuery appendString:@"?"];
        } else {
            [urlWithQuery appendString:@"&"];
        }
        [urlWithQuery appendString:key];
        [urlWithQuery appendString:@"="];
        
        NSString *value = [[para objectForKey:key] description];
        [urlWithQuery appendString:value];
    }];
    return [urlWithQuery stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark --public
- (void)fyStartWithCompletionBlockWithSuccess:(nullable YTKRequestCompletionBlock)success {
    if (!self.hideLoading) {
        [FYProgressHUD showLoading];
    }
    __weak typeof(self)weakSelf = self;
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf printLogWithTitle:@"成功" requestResult:request];
        if (!weakSelf.hideLoading) {
            [FYProgressHUD hideLoading];
        }
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf printLogWithTitle:@"失败" requestResult:request];
        if (request.responseStatusCode == 401) {  //跳到首页 再弹出 登录界面
             [FYProgressHUD hideLoading];
            [[FYRouter sharedRouter] clearUserInfoAndgotoLogin];
            return ;
        }else if (request.responseStatusCode == 403) { //无权限
            NSString *errorMessage = @"";
            if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
                errorMessage = [request.responseJSONObject objectForKey:@"message"];
            }
            if (![NSString isEmpty:errorMessage] && !weakSelf.hideErrorMessage) {
                [FYProgressHUD showToastStatus:errorMessage];
            }else {
                 [FYProgressHUD showToastStatus:@"您的账户没有该权限!"];
            }
        }else if (request.responseStatusCode == 500) { //测试环境下 500后 不执行其他操作
            [FYProgressHUD showErrorInfoMessage:request.error errorCode:request.responseStatusCode];
        }else{
            NSString *errorMessage = @"";
            if ([request.responseJSONObject isKindOfClass:[NSDictionary class]]) {
               errorMessage = [request.responseJSONObject objectForKey:@"message"];
            }
            if (![NSString isEmpty:errorMessage] && !weakSelf.hideErrorMessage) {
                [FYProgressHUD showToastStatus:errorMessage];
            }else {
                    [FYProgressHUD hideLoading];
            }
        }
        [self showErrorMessageWithError:request.error];
    }];
}

- (void)fyStartWithCompletionBlockWithSuccess:(nullable YTKRequestCompletionBlock)success
                                      failure:(nullable YTKRequestCompletionBlock)failure {
    __weak typeof(self)weakSelf = self;
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf printLogWithTitle:@"成功" requestResult:request];
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf printLogWithTitle:@"失败" requestResult:request];
        if (request.responseStatusCode == 401) {  //跳到首页 再弹出 登录界面
            [[FYRouter sharedRouter] clearUserInfoAndgotoLogin];
            return ;
        }else if (request.responseStatusCode == 403) { //无权限
            [FYProgressHUD showToastStatus:@"您的账户没有该权限!"];
            return ;
        }else if (request.responseStatusCode == 500) {  
            [FYProgressHUD showErrorInfoMessage:request.error errorCode:request.responseStatusCode];
        }
        
        [self showErrorMessageWithError:request.error];

        failure(request);
    }];
}

- (void)fy_DetailStartWithCompletionBlockWithSuccess:(nullable YTKRequestCompletionBlock)success
                                      failure:(nullable YTKRequestCompletionBlock)failure {
    __weak typeof(self)weakSelf = self;
    [self startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [weakSelf printLogWithTitle:@"成功" requestResult:request];
        success(request);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
         [weakSelf printLogWithTitle:@"失败" requestResult:request];
        if (request.responseStatusCode == 401) {  //跳到首页 再弹出 登录界面
            [FYProgressHUD hideLoading];
            [[FYRouter sharedRouter] clearUserInfoAndgotoLogin];
            return ;
        }
        [self showErrorMessageWithError:request.error];
        failure(request);
    }];
}

/**
 网络请求成功，统一处理逻辑
 */
- (void)requestCompleteFilter {
    
}

//提示网络错误信息
- (void)showErrorMessageWithError:(NSError *)error {
    if (error) {
        if (error.code == -999 || error.code == -1012 || error.code == -1000 || error.code == -1001 || error.code == -1103 || error.code == -1005 || error.code == -1009) {
            [FYProgressHUD showToastStatus:@"当前网络异常!"];
        }
    }
}

#pragma mark --prative

//请求类型转换
- (NSString *)requestType {
    YTKRequestMethod method = [self requestMethod];
    switch (method) {
        case YTKRequestMethodGET:
            return @"Get";
            break;
        case YTKRequestMethodPOST:
            return @"Post";
            break;
        case YTKRequestMethodHEAD:
            return @"Head";
            break;
        case YTKRequestMethodPUT:
            return @"Put";
            break;
        case YTKRequestMethodDELETE:
            return @"Delete";
            break;
        case YTKRequestMethodPATCH:
            return @"Patch";
            break;
        default:
            return @"";
            break;
    }
}

- (void)printLogWithTitle:(NSString *)title requestResult:(YTKBaseRequest*)requestResult {
    NSString *requestUrl = [NSString stringWithFormat:@"%@/%@",[self baseUrl],[self requestUrl]];
    FYRequestLog(title,NSStringFromClass([self class]),requestUrl, [self requestType], [self requestArgument], requestResult.responseJSONObject);
}

-(NSString *)convertToJsonData:(NSDictionary *)dict
{
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    NSString *jsonString;
    if (!jsonData) {
        NSLog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    return mutStr;
}

+ (BOOL)verifyCode:(NSInteger)code {
    BOOL result = YES;
    if (code>=200 && code<300) {
        return YES;
    }else {
        return NO;
    }
    return result;
}

- (BOOL)isVerifided{
  return  [FYBaseApi verifyCode:self.responseStatusCode];
}

- (NSString *)apiVersion {
    return nil;
}

@end
