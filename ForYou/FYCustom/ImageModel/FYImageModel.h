//
//  RWHImageModel.h
//  Pods
//
//  Created by zy on 16/11/16.
//
//  DESC 图片文件，缓存uiimage到硬盘，并被使用
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FYImageModel : NSObject

@property (nonatomic ,strong) NSString *title;       //图片标题

@property (nonatomic ,strong) NSString *name;         //图片名称
@property (nonatomic ,strong) NSString *urlString;     //url路径
@property (nonatomic ,readonly) NSString *localPath;   //本地路径
@property (assign) CGSize size;                        //图片尺寸

@property (nonatomic ,readonly) BOOL isValid;            //文件是否有效
//uploading
@property (nonatomic ,assign) double fractionCompleted;  //完成进度
@property (nonatomic ,assign) BOOL isUploadingFinished; //是否完成上传
@property (nonatomic, assign) BOOL isUploadSuccess;     //是否成功上传
@property (nonatomic ,assign) BOOL isHideImageTag;     //是否隐藏图片标签  默认不隐藏
@property (nonatomic ,copy) NSString *imageTagID;       //图片标签ID
@property (nonatomic ,copy) NSString *imageTagName;     //图片标签名称
@property (nonatomic, assign) BOOL isCustomTag;         //是否为自定义标签 默认NO
@property (nonatomic, copy) NSString *imageType;        //图片类型
@property (nonatomic, copy) NSString *imageID;          //图片ID

 /**
  根据短文件名 将image从内存持久化到沙盒

  @return nil ,if image is bad
  */
- (instancetype)initWithWithUIImage:(UIImage *) imageInMemory
                       andImageName:(NSString *) name;
+ (instancetype)imageModelWithUIImage:(UIImage *) imageInMemory
                         andImageName:(NSString *) name;



/**
 远程http url得到模型

 @param urlString
 @return nil，if url null
 */
- (instancetype)initWithHttpUrl:(NSString *)urlString;
+ (instancetype)imageModelFromUrl:(NSString *)urlString;


/*
 * 根据短文件名
 * 若不存在图片文件，就返回nil
 */
+ (instancetype)imageModelWithCertainNameFromDocument:(NSString *) imageFilename;

+ (void)clearAllImageModel;

- (NSString *)base64String;

@end
