//
//  FYAddPhotoTableCell.h
//  ForYou
//
//  Created by marcus on 2017/8/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//  添加照片Cell

#import <UIKit/UIKit.h>
#import "FYBaseTableViewCell.h"

typedef void(^clickImagesCellBlock)(NSInteger);

@interface FYAddPhotoTableCell : FYBaseTableViewCell

@property (nonatomic,copy) clickImagesCellBlock clickImagesCellBlock;

+ (CGFloat)photoItemCellHeightWithCount:(NSInteger)count maxCount:(NSInteger)maxCount title:(NSString *)title;

@end
