//
//  FYImageUploader.m
//  OCTest
//
//  Created by marcus on 2017/8/9.
//  Copyright © 2017年 marcus. All rights reserved.
//

#import "FYImageUploader.h"
#import <AFNetworking/AFNetworking.h>
#import "FYAPIConfiguration.h"
#import "FYUserDefaults.h"
#import "UIDevice+FYCategory.h"
#import "FYDefines.h"

@interface FYImageUploader()

@property (nonatomic ,strong) NSMutableArray<FYImageModel *> *imageModels;
@property (nonatomic ,strong) NSString *token;//qiniu token
@property (nonatomic ,strong) NSOperationQueue *optQueue;
@property (copy) FYImageUploaderCallback callback;

@end

@implementation FYImageUploader
@synthesize uploadingImages = _uploadingImages;

- (instancetype)initWithImageModels:(NSArray<FYImageModel *> *)images{
    if (self = [super init]) {
        _uploadingImages = _imageModels = [[NSMutableArray alloc] initWithArray:images];
        _optQueue = [[NSOperationQueue alloc] init];
        _maxConcurrenceCount = 5;
        _optQueue.maxConcurrentOperationCount = _maxConcurrenceCount;
    }
    return self;
}

- (void)dealloc{
    [self.optQueue cancelAllOperations];
    self.optQueue = nil;
}

- (void)startWithCallBack:(FYImageUploaderCallback)callback{
    _callback = callback;
    __weak typeof(self) weakSelf = self;
    [self.imageModels enumerateObjectsUsingBlock:^(FYImageModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isValid) {
            [weakSelf.optQueue addOperationWithBlock:^{
                [weakSelf _uploadImageModel:obj];
            }];
        }
    }];
}

- (void)pause{
    [self.optQueue setSuspended:YES];
}

- (void)stop{
    [self.optQueue cancelAllOperations];
}

- (void)resume{
    [self.optQueue setSuspended:NO];
}

#pragma mark --setter

- (void)setMaxConcurrenceCount:(NSInteger)maxConcurrenceCount{
    if (maxConcurrenceCount != _maxConcurrenceCount) {
        _maxConcurrenceCount = maxConcurrenceCount;
        self.optQueue.maxConcurrentOperationCount = _maxConcurrenceCount;
    }
}

#pragma mark --private
- (void)_uploadImageModel:(FYImageModel *)model{
    if (model.urlString.length) {
        return;
    }
    
    NSString *host = [NSString stringWithFormat:@"%@/%@",[FYAPIConfiguration currentConfiguration].baseUrl,@"file/merchant/rms/files"];
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    mgr.requestSerializer = [AFJSONRequestSerializer serializer];
    mgr.responseSerializer = [AFJSONResponseSerializer new];
    mgr.requestSerializer.timeoutInterval = kFYNetworkingTimeoutSeconds;
    [mgr.requestSerializer setValue:@"8888" forHTTPHeaderField:@"x-ForYou-app-id"];
    [mgr.requestSerializer setValue:@"" forHTTPHeaderField:@"x-ForYou-app-sign"];
    [mgr.requestSerializer setValue:@"application/vnd.ForYou.v1+json" forHTTPHeaderField:@"Accept"];
    NSString *token = [FYUserDefaults sharedInstance].accessToken;
    token = (!token ? @"" : token);
    [mgr.requestSerializer setValue:token forHTTPHeaderField:@"Authorization"];
    [mgr.requestSerializer setValue:[UIDevice currentDevice].modelName?:@"" forHTTPHeaderField:@"x-fy-device-name"];
    [mgr.requestSerializer setValue:[UIDevice currentDevice].deviceID?:@"" forHTTPHeaderField:@"x-fy-device-unique-key"];
    [mgr.requestSerializer setValue:@"application/vnd.ForYou.v1+json" forHTTPHeaderField:@"produces"];

    mgr.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];

    __weak typeof(self) weakSelf = self;
    [mgr POST:host parameters:@{@"fileTypeId":@(3)} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSData *data =  [NSData dataWithContentsOfFile:model.localPath];
        NSString *name = model.name;
        NSString *formKey = @"file";
        NSString *type = model.imageType;
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        model.fractionCompleted = uploadProgress.fractionCompleted;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"图片上传成功：%@",responseObject);
        NSDictionary *dic = responseObject;
        model.imageID = [dic objectForKey:@"id"];
        model.urlString = [dic objectForKey:@"url"];
        model.isUploadingFinished = YES;
        model.isUploadSuccess = YES;
        if (weakSelf.callback) {
            [weakSelf _doCallBack];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        model.isUploadingFinished = YES;
        model.isUploadSuccess = NO;
    }];
    
}

- (void)_doCallBack{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (self.callback) {
            self.callback(self);
        }
    });
}
@end
