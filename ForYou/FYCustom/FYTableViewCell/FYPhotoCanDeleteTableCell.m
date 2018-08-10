//
//  FYPhotoCanDeleteTableCell.m
//  ForYou
//
//  Created by marcus on 2018/1/10.
//  Copyright © 2018年 ForYou. All rights reserved.
//

#import "FYPhotoCanDeleteTableCell.h"
#import "FYPhotoItemCanDeleteCollectionCell.h"

@interface FYPhotoCanDeleteTableCell()<UICollectionViewDataSource, UICollectionViewDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (nonatomic, assign) NSInteger maxCount;
@end

static NSString *kFYPhotoItemCanDeleteCollectionCellID = @"FYPhotoItemCanDeleteCollectionCellID";

@implementation FYPhotoCanDeleteTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createDefaultStyle];
}

- (void)createDefaultStyle {
    self.maxCount = 20;
    self.canEdit = YES;
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake([FYPhotoCanDeleteTableCell photoImageWidth], [FYPhotoCanDeleteTableCell photoImageHeight]);
    layout.minimumInteritemSpacing = ScreenWidth-[FYPhotoCanDeleteTableCell photoImageWidth]*2.0-32;
    layout.minimumLineSpacing = 8.0;
    layout.sectionInset = UIEdgeInsetsMake(20,16,20,16);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FYPhotoItemCanDeleteCollectionCell" bundle:nil]  forCellWithReuseIdentifier:kFYPhotoItemCanDeleteCollectionCellID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
}

#pragma mark -- UICollectionViewDataSource
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.canEdit) {
         return self.dataArray.count>=self.maxCount ? self.maxCount: self.dataArray.count+1;
    }else {
        return self.dataArray.count>=self.maxCount ? self.maxCount: self.dataArray.count;
    }
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYPhotoItemCanDeleteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFYPhotoItemCanDeleteCollectionCellID forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        FYImageModel *model = self.dataArray[indexPath.row];
        cell.isAdd = NO;
        cell.index = indexPath.row;
        cell.canEdit = self.canEdit;
        cell.deleteImageBlock = ^(NSInteger index) {
            if (self.deleteImageBlock) {
                self.deleteImageBlock(index);
            }
        };
        [cell refreshViewWithData:model];
    }else {
        cell.isAdd = YES;
        cell.index = indexPath.row;
        cell.deleteImageBlock = ^(NSInteger index) {
            if (self.deleteImageBlock) {
                self.deleteImageBlock(index);
            }
        };
        [cell refreshViewWithData:nil];
    }
    
    return cell;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.maxCount = self.cellModel.cellTag;
    self.dataArray = [self.dataModel valueForKey:@"photos"];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.clickImageBlock) {
        self.clickImageBlock(indexPath.row);
    }
}

- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}

+ (CGFloat)photoImageWidth {
    return floor((ScreenWidth-16*2-11)/2.0);
}

+ (CGFloat)photoImageHeight {  //宽高比 4：3
    return floor(((ScreenWidth-16*2-11)*3.0)/8.0);
}

+ (CGFloat)photoItemCellHeightWithCount:(NSInteger)count canEdit:(BOOL)canEdit {
    NSInteger row = canEdit ? ceilf((count+1)/2.0) : ceilf((count)/2.0);
    row = row>=10?10:row;
    return (20+row*[FYPhotoCanDeleteTableCell photoImageHeight]+(row-1)*8+20);
}

@end
