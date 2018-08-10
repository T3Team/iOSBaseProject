//
//  RWHImageModel.m
//  Pods
//
//  Created by zy on 16/11/16.
//
//

#import "FYImageModel.h"
#import "NSString+FYCategory.h"

@implementation FYImageModel
@synthesize isValid = _isValid;

- (instancetype)initWithWithUIImage:(UIImage *)imageInMemory andImageName:(NSString *)name{
    if (self = [super init]) {
        _name = name;
        NSData *imageData = UIImageJPEGRepresentation(imageInMemory, 1.0);
        _imageType = @"image/jpeg";
        if (!imageData) {
            imageData = UIImagePNGRepresentation(imageInMemory);
            _imageType = @"image/png";
        }
        NSURL *url = [NSURL fileURLWithPath:self.localPath];
        if (imageData) {
            _isValid = YES;
            self.size = imageInMemory.size;
            [imageData writeToURL:url atomically:YES];
        } else{
            _isValid = NO;
        }
    }
    return self;
}

+ (instancetype)imageModelWithUIImage:(UIImage *)imageInMemory
                         andImageName:(NSString *)name{
    FYImageModel *model = [[FYImageModel alloc] initWithWithUIImage:imageInMemory andImageName:name];
    return model;
}

- (instancetype)initWithHttpUrl:(NSString *)urlString{
    if (self = [super init]) {
        _name = @"";
        if (urlString.length) {
            _isValid = YES;
            _urlString = [urlString copy];
        } else{
            _isValid = NO;
        }
    }
    return self;
}

+ (instancetype)imageModelFromUrl:(NSString *)urlString{
    FYImageModel *model = [[FYImageModel alloc] initWithHttpUrl:urlString];
    return model;
}

+ (instancetype)imageModelWithCertainNameFromDocument:(NSString *) imageFilename{
    NSString *documentPath = [FYImageModel _imageDocumentPath];
    NSString *pathString = [documentPath stringByAppendingPathComponent:imageFilename];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathString]) {
        FYImageModel *model = [FYImageModel new];
        model.name = imageFilename;
        return model;
    } else {
        return nil;
    }
}
    
- (NSString *)localPath{
    if (![NSString isEmpty:self.name]) {
        NSString *documentPath = [FYImageModel _imageDocumentPath];
        NSString *pathString = [documentPath stringByAppendingPathComponent:self.name];
        return pathString;
    }else {
        return nil;
    }
}
    
+ (NSString *)_imageDocumentPath{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"FYImages"];
    if (NO == [[NSFileManager defaultManager] fileExistsAtPath:documentsDirectory]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return documentsDirectory;
}

+ (void)clearAllImageModel{
    NSString *documentPath = [FYImageModel _imageDocumentPath];
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentPath];
    for (NSString *fileName in enumerator) {
        [[NSFileManager defaultManager] removeItemAtPath:[documentPath stringByAppendingPathComponent:fileName] error:nil];
    }
}

- (NSString *)base64String{
    NSData *imageData = [NSData dataWithContentsOfFile:self.localPath];
    NSString *base64Encoded = [imageData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return base64Encoded;
}

@end
