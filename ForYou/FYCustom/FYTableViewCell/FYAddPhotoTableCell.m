//
//  FYAddPhotoTableCell.m
//  ForYou
//
//  Created by marcus on 2017/8/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYAddPhotoTableCell.h"
#import "FYPhotoItemCollectionCell.h"
#import "FYImageModel.h"

@interface FYAddPhotoTableCell()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *titileLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;

/**
 照片信息数组
 */
@property (nonatomic, weak) NSMutableArray *dataArray;

@property (nonatomic, assign) NSInteger maxCount;
@end

#define photoImgHeight 68
static NSString *kFYPhotoItemCollectionCellID = @"kFYPhotoItemCollectionCellID";

@implementation FYAddPhotoTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self createDefaultStyle];
}

- (void)createDefaultStyle {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(photoImgHeight, photoImgHeight);
    NSLog(@"%f",ScreenWidth);
    layout.minimumInteritemSpacing = floorf((ScreenWidth-photoImgHeight*4.0-32)/3.0);
    layout.minimumLineSpacing = 20.0;
    layout.sectionInset = UIEdgeInsetsMake(20,16,20,16);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView.collectionViewLayout = layout;
    [self.collectionView registerNib:[UINib nibWithNibName:@"FYPhotoItemCollectionCell" bundle:nil]  forCellWithReuseIdentifier:kFYPhotoItemCollectionCellID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.scrollEnabled = NO;
    self.maxCount = 20;
}

#pragma mark -- UICollectionViewDataSource 
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count>=self.maxCount ? self.maxCount: self.dataArray.count+1;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYPhotoItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFYPhotoItemCollectionCellID forIndexPath:indexPath];
    if (indexPath.row < self.dataArray.count) {
        FYImageModel *model = self.dataArray[indexPath.row];
        cell.isAdd = NO;
        [cell refreshViewWithData:model];
    }else {
        cell.isAdd = YES;
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
    if ([NSString isEmpty:self.cellModel.cellTitle] || [self.cellModel.cellTitle isEqualToString:@"图片选择"]) {  //没有title  或者 title为图片选择 特殊处理
        self.topConstraint.constant = 0.0;
        self.titileLabel.text = @"";
    }else {
        self.topConstraint.constant = 20.0;
        self.titileLabel.text = self.cellModel.cellTitle;
    }
    self.dataArray = [self.dataModel valueForKey:@"photos"];
    [self.collectionView reloadData];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if(self.clickImagesCellBlock) {
        self.clickImagesCellBlock(indexPath.row);
    }
}

+ (CGFloat)photoItemCellHeightWithCount:(NSInteger)count maxCount:(NSInteger)maxCount title:(NSString *)title{
    NSInteger row = ceilf((count+1)/4.0);
    NSInteger maxRow = ceilf(maxCount/4.0);
    row = row>=maxRow?maxRow:row;
    return [NSString isEmpty:title] ? row*88+20 : row*88+42;
}

@end
