//
//  FYItemSelectTableCell.h
//  ForYou
//
//  Created by marcus on 2017/8/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//  items选择项 

#import <UIKit/UIKit.h>
#import "FYBaseTableViewCell.h"

@interface FYItemSelectTableCell : FYBaseTableViewCell

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

+ (CGFloat)selectedItemCellHeightWithCount:(NSInteger)count;

- (void)refreshViewWithData;

- (void)refreshDataWithSelected;

@end
