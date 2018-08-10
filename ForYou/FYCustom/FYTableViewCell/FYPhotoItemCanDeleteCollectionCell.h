//
//  FYPhotoItemCanDeleteCollectionCell.h
//  ForYou
//
//  Created by marcus on 2018/1/10.
//  Copyright © 2018年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYImageModel.h"
#import "FYBlock.h"

@interface FYPhotoItemCanDeleteCollectionCell : UICollectionViewCell

/**
 是否为添加图片标志 默认为否
 */
@property (nonatomic, assign) BOOL isAdd;

//是否可编辑 默认为YES
@property (nonatomic, assign) BOOL canEdit;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, copy) FYParameterIntBlock deleteImageBlock;

- (void)refreshViewWithData:(FYImageModel*)imageModel;

@end
