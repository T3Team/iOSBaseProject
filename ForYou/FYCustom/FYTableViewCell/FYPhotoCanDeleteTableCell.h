//
//  FYPhotoCanDeleteTableCell.h
//  ForYou
//
//  Created by marcus on 2018/1/10.
//  Copyright © 2018年 ForYou. All rights reserved.
//  图片Cell 右上角带删除按钮

#import <UIKit/UIKit.h>
#import "FYBaseTableViewCell.h"
#import "FYImageModel.h"

@interface FYPhotoCanDeleteTableCell : FYBaseTableViewCell

/**
 照片信息数组
 */
@property (nonatomic, weak) NSMutableArray<FYImageModel*> *dataArray;

//是否可编辑 默认为YES
@property (nonatomic, assign) BOOL canEdit;

//点击图片 回调
@property (nonatomic,copy) FYParameterIntBlock clickImageBlock;

//点击删除按钮  回调
@property (nonatomic,copy) FYParameterIntBlock deleteImageBlock;


+ (CGFloat)photoItemCellHeightWithCount:(NSInteger)count canEdit:(BOOL)canEdit;

@end
