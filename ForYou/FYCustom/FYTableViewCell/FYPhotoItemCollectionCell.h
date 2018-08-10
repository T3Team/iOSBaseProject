//
//  FYPhotoItemCollectionCell.h
//  ForYou
//
//  Created by marcus on 2017/8/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYImageModel.h"

@interface FYPhotoItemCollectionCell : UICollectionViewCell

/**
 是否为添加图片标志 默认为否
 */
@property (nonatomic, assign) BOOL isAdd;

- (void)refreshViewWithData:(FYImageModel*)imageModel;

@end
