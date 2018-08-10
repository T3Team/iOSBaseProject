//
//  FYItemSelectTableCell.m
//  ForYou
//
//  Created by marcus on 2017/8/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYItemSelectTableCell.h"
#import "FYHeader.h"
#import "FYSelectItemCollectionCell.h"

@interface FYItemSelectTableCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 item选项数组
 */
@property (nonatomic, weak) NSMutableArray *dataArray;

/**
 记录选中的indexPath
 */
@property (nonatomic, strong) NSMutableArray *selectIndexPathArray;
@property (weak, nonatomic) IBOutlet UIView *line;
@end

static NSString *kFYSelectItemCollectionCellID = @"kFYSelectItemCollectionCellID";

#define kItemSpacing 8.0
#define kItemHeight 31.0
#define kLineSpacing 8.0

@implementation FYItemSelectTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createDefaultStyle];
}

- (void)createDefaultStyle {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([self defaultWidth], kItemHeight);
    layout.minimumInteritemSpacing = kItemSpacing;
    layout.minimumLineSpacing = kLineSpacing;
    layout.sectionInset = UIEdgeInsetsMake(0,16,16,16);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FYSelectItemCollectionCell" bundle:nil]  forCellWithReuseIdentifier:kFYSelectItemCollectionCellID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    self.selectIndexPathArray = [[NSMutableArray alloc] init];
}

#pragma mark -- UICollectionViewDataSource
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYSelectItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFYSelectItemCollectionCellID forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        cell.label.text = [dic valueForKey:@"name"];
    }
    [cell refreshViewWithSelected:[self.selectIndexPathArray containsObject:indexPath]];
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    FYSelectItemCollectionCell *cell = (FYSelectItemCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    if ([self.selectIndexPathArray containsObject:indexPath]) {  //已选中的情况下，再次点击则反选
        if (self.cellModel.mustInput && self.selectIndexPathArray.count == 1) {  //如果必选时，最后只剩下一项时，不可反选
            return;
        }
        [cell refreshViewWithSelected:NO];
        if ([self.selectIndexPathArray containsObject:indexPath]) {
            [self.selectIndexPathArray removeObject:indexPath];
        }
    }else {
        if (self.cellModel.cellTag==0) {  //单选时，需要取消其他选中项
            for (NSIndexPath *indexPathTemp in self.selectIndexPathArray) {
                FYSelectItemCollectionCell *cellTemp = (FYSelectItemCollectionCell*)[collectionView cellForItemAtIndexPath:indexPathTemp];
                [cellTemp refreshViewWithSelected:NO];
                if ([self.selectIndexPathArray containsObject:indexPathTemp]) {
                    [self.selectIndexPathArray removeObject:indexPathTemp];
                }            }
        }
        if (![self.selectIndexPathArray containsObject:indexPath]) {
            [self.selectIndexPathArray addObject:indexPath];
        }
        [cell refreshViewWithSelected:YES];
    }
    
    [self refreshDataWithSelected];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = [self defaultWidth];
    if (indexPath.row < self.dataArray.count) {
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSString *title = [dic valueForKey:@"name"];
        CGFloat titleLength = [title stringLengthWithFont:[UIFont systemFontOfSize:13]];
        itemWidth = (titleLength > itemWidth) ? (itemWidth*2) + kItemSpacing : itemWidth ;
    }
    return CGSizeMake(itemWidth, kItemHeight);
}


- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.titleLabel.text = self.cellModel.cellTitle;
    self.line.hidden = !self.cellModel.showLine;
    self.dataArray = [self.dataModel valueForKey:self.cellModel.key];
    [self refreshViewWithData];
    [self.collectionView reloadData];
}

- (void)refreshViewWithData {
    NSRange range = [self.cellModel.key rangeOfString:@"List"];
    NSString *selectKey = [self.cellModel.key substringToIndex:range.location];
    if (!(self.cellModel.cellTag == 0)) {
        NSArray *array = [self.dataModel valueForKey:selectKey];
        for (int i=0; i<self.dataArray.count; i++) {
            NSDictionary *dic = self.dataArray[i];
            if ([array containsObject:[dic valueForKey:@"name"]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                if (![self.selectIndexPathArray containsObject:indexPath]) {
                    [self.selectIndexPathArray addObject:indexPath];
                }            }
        }
    } else {
        NSString *selectedName = [self.dataModel valueForKey:selectKey];
        if (![NSString isEmpty:selectedName]) {
            for (int i=0; i<self.dataArray.count; i++) {
                NSDictionary *dic = self.dataArray[i];
                if ([selectedName isEqualToString:[dic valueForKey:@"name"]]) {
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                    if (![self.selectIndexPathArray containsObject:indexPath]) {
                        [self.selectIndexPathArray addObject:indexPath];
                    }
                }
            }
        }
    }
}

- (void)refreshDataWithSelected {
    NSRange range = [self.cellModel.key rangeOfString:@"List"];
    NSString *selectKey = [self.cellModel.key substringToIndex:range.location];
    if (!(self.cellModel.cellTag == 0)) {
        NSMutableArray *selectsArray = [[NSMutableArray alloc]init];
        if (self.selectIndexPathArray && self.selectIndexPathArray.count>0) {
            for (NSIndexPath *indexPath in self.selectIndexPathArray) {
                NSDictionary *dic = self.dataArray[indexPath.row];
                [selectsArray addObject:[dic valueForKey:@"name"]];
            }
            [self.dataModel setObject:selectsArray forKey:selectKey];
        }else {
            [self.dataModel setObject:[[NSMutableArray alloc]init] forKey:selectKey];
        }
    }else {
        if (self.selectIndexPathArray && self.selectIndexPathArray.count>0) {
            for (NSIndexPath *indexPath in self.selectIndexPathArray) {
                NSDictionary *dic = self.dataArray[indexPath.row];
                [self.dataModel setObject:[dic valueForKey:@"name"] forKey:selectKey];
                break;
            }
        }else {
            [self.dataModel setObject:@"" forKey:selectKey];
        }
    }
}

- (CGFloat)defaultWidth {
    return floorf((ScreenWidth-24-32)/4.0);
}

+ (CGFloat)selectedItemCellHeightWithCount:(NSInteger)count {
    NSInteger row = ceilf((count)/4.0);
    return row*31 + (row-1)*8 + 61;
}

- (NSString *)checkMustInputBecomeFirstResponder:(BOOL)become {
    NSString *result = nil;
    if (self.cellModel.mustInput) {
        if (!(self.collectionView.indexPathsForSelectedItems && self.collectionView.indexPathsForSelectedItems.count>0)) {
            result = [NSString stringWithFormat:@"请选择%@",self.cellModel.cellTitle];
        }
    }
    return result;
}

@end
