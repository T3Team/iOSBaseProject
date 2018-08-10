//
//  FYSingleLineItemSelectTableCell.m
//  ForYou
//
//  Created by marcus on 2017/9/20.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYSingleLineItemSelectTableCell.h"
#import "FYSelectItemCollectionCell.h"
#import "FYHeader.h"

@interface FYSingleLineItemSelectTableCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *collectionViewWidthConstraints;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mustInputMark;
@property (weak, nonatomic) IBOutlet UIView *lineView;

/**
 item选项数组
 */
@property (nonatomic, weak) NSMutableArray *dataArray;
/**
 记录选中的indexPath
 */
@property (nonatomic, strong) NSMutableArray *selectIndexPathArray;
@end

static NSString *kFYSelectItemCollectionCellID = @"kFYSelectItemCollectionCellID";

#define kItemSpacing 10.0
#define kItemHeight 28.0

@implementation FYSingleLineItemSelectTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createDefaultStyle];
}

- (void)createDefaultStyle {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = kItemSpacing;
    layout.minimumLineSpacing = kItemSpacing;
    layout.sectionInset = UIEdgeInsetsMake(0,0,0,0);
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
                }
            }
        }
        if (![self.selectIndexPathArray containsObject:indexPath]) {
            [self.selectIndexPathArray addObject:indexPath];
        }
        [cell refreshViewWithSelected:YES];
    }
    if (self.cellModel.valueChangeBlock) {
        self.cellModel.valueChangeBlock();
    }
    [self refreshDataWithSelected];
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dic = self.dataArray[indexPath.row];
    CGFloat itemWidth = [self itemWidthWithTitle:[dic valueForKey:@"name"]];
    return CGSizeMake(itemWidth, kItemHeight);
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.lineView.hidden = !self.cellModel.showLine;
    self.titleLabel.text = self.cellModel.cellTitle;
    self.dataArray = [self.dataModel valueForKey:[NSString stringWithFormat:@"%@List",self.cellModel.key]];
    self.mustInputMark.hidden = !self.cellModel.mustInput;
    CGFloat width = 0;
    for (NSDictionary *dic in self.dataArray) {
        NSString *title = [dic valueForKey:@"name"];
        width += [self itemWidthWithTitle:title];
    }
    width += (self.dataArray.count-1)*kItemSpacing;
    self.collectionViewWidthConstraints.constant = width;
    self.collectionView.hidden = !self.cellModel.canEdit;
    self.valueLabel.hidden = self.cellModel.canEdit;
    if (self.cellModel.canEdit) {
        [self refreshViewWithData];
        [self.collectionView reloadData];
    }else {
        id temp = [self.dataModel valueForKey:self.cellModel.key];
        if ([temp isKindOfClass:[NSArray class]] || [temp isKindOfClass:[NSMutableArray class]]) {
            NSString *value = @"";
            for (NSString *str in temp) {
                value = [NSString stringWithFormat:@"%@ %@",value,str];
            }
            self.valueLabel.text = temp;
        }else if(![NSString isEmpty:temp]){
            self.valueLabel.text = temp;
        }
    }    
}

- (void)refreshViewWithData {
    if (!(self.cellModel.cellTag == 0)) {
        NSArray *array = [self.dataModel valueForKey:self.cellModel.key];
        for (int i=0; i<self.dataArray.count; i++) {
            NSDictionary *dic = self.dataArray[i];
            if ([array containsObject:[dic valueForKey:@"name"]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                if (![self.selectIndexPathArray containsObject:indexPath]) {
                    [self.selectIndexPathArray addObject:indexPath];
                }
            }
        }
    } else {
        NSString *selectedName = [self.dataModel valueForKey:self.cellModel.key];
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
    if (!(self.cellModel.cellTag == 0)) {
        NSMutableArray *selectsArray = [[NSMutableArray alloc]init];
        if (self.selectIndexPathArray && self.selectIndexPathArray.count>0) {
            for (NSIndexPath *indexPath in self.selectIndexPathArray) {
                NSDictionary *dic = self.dataArray[indexPath.row];
                [selectsArray addObject:[dic valueForKey:@"name"]];
            }
            [self.dataModel setObject:selectsArray forKey:self.cellModel.key];
        }else {
            [self.dataModel setObject:[[NSMutableArray alloc]init] forKey:self.cellModel.key];
        }
    }else {
        if (self.selectIndexPathArray && self.selectIndexPathArray.count>0) {
            for (NSIndexPath *indexPath in self.selectIndexPathArray) {
                NSDictionary *dic = self.dataArray[indexPath.row];
                [self.dataModel setObject:[dic valueForKey:@"name"] forKey:self.cellModel.key];
                break;
            }
        }else {
            [self.dataModel setObject:@"" forKey:self.cellModel.key];
        }
    }
}

- (CGFloat)itemWidthWithTitle:(NSString *)title {
    CGFloat itemWidth;
    if (title.length == 1) {
        itemWidth = 40;
    }else if(title.length == 2) {
        itemWidth = 48;
    }else {
        CGFloat titleLength = [title stringLengthWithFont:[UIFont systemFontOfSize:13]];
        itemWidth = floor(titleLength + 22);
    }
    return itemWidth;
}

- (NSString *)checkMustInputBecomeFirstResponder:(BOOL)become {
    NSString *result = nil;
    if (self.cellModel.mustInput) {
        [self refreshDataWithSelected];
        if (!(self.cellModel.cellTag == 0)) {
            NSArray *tempArray = [self.dataModel objectForKey:self.cellModel.key];
            if (!(tempArray && tempArray.count>0)) {
                result = [NSString stringWithFormat:@"请选择%@",self.cellModel.cellTitle];
            }
        }else {
            NSString *value = [self.dataModel objectForKey:self.cellModel.key];
            if ([NSString isEmpty:value]) {
                result = [NSString stringWithFormat:@"请选择%@",self.cellModel.cellTitle];
            }
        }

    }
    return result;
}

@end
