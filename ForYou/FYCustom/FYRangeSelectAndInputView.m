//
//  FYRangeSelectAndInputView.m
//  ForYou
//
//  Created by marcus on 2017/9/25.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYRangeSelectAndInputView.h"
#import "FYHeader.h"
#import "FYSelectItemCollectionCell.h"
#import "FYRangeInputCollectionCell.h"
#import "FYCollectionViewFlowLayout.h"

@interface FYRangeSelectAndInputView()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) BOOL hasInput; //是否有自定义输入项
@property (nonatomic, assign) BOOL bInput;   //是否为自定义输入的内容
@property (nonatomic, assign) BOOL mustInput; //是否必填
@property (nonatomic, assign) BOOL multiple;  //是否多选  默认 NO
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSString *selectItemName;
@property (nonatomic, weak) FYRangeInputCollectionCell* rangeInputCell;
/**
 记录选中的indexPath
 */
@property (nonatomic, strong) NSMutableArray *selectIndexPathArray;

@end

static NSString *kFYSelectItemCollectionCellID = @"kFYSelectItemCollectionCellID";
static NSString *kFYRangeInputCollectionCellID = @"kFYRangeInputCollectionCellID";

#define kItemSpacing 8.0
#define kItemHeight 31.0
#define kLineSpacing 16.0

@implementation FYRangeSelectAndInputView

-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        [self createDefaultView];
    }
    return self;
}

- (void)refreshViewWithData:(NSArray *)data title:(NSString *)title hasInput:(BOOL)hasInput selectItemName:(NSString *)selectItemName mustInput:(BOOL)mustInput multiple:(BOOL)multiple{
    self.titleLabel.text = [NSString stringWithFormat:@"%@%@",title,multiple?@"(多选)":@""];
    self.title = title;
    self.data = data;
    self.hasInput = hasInput;
    self.selectItemName = selectItemName;
    self.mustInput = mustInput;
    self.multiple = multiple;
    self.confirmButton.hidden = !self.multiple;
    if (self.hasInput) {
        self.bInput = YES;
    }
    for (NSDictionary *dic in self.data) {
        if ([[dic objectForKey:@"name"] isEqualToString:selectItemName]) {
            self.bInput = NO;
            break;
        }
    }
    [self.selectIndexPathArray removeAllObjects];
    [self refreshViewWithData];
    [self.collectionView reloadData];
}

- (void)refreshViewWithData {
    if (self.multiple) { //多选
        NSArray *array = [self.selectItemName componentsSeparatedByString:@","];
        for (int i=0; i<self.data.count; i++) {
            NSDictionary *dic = self.data[i];
            if ([array containsObject:[dic valueForKey:@"name"]]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                if (![self.selectIndexPathArray containsObject:indexPath]) {
                    [self.selectIndexPathArray addObject:indexPath];
                }
            }
        }
    } else {
        NSString *selectedName = self.selectItemName;
        if (![NSString isEmpty:selectedName]) {
            for (int i=0; i<self.data.count; i++) {
                NSDictionary *dic = self.data[i];
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

#pragma mark -- UICollectionViewDataSource
/** 每组cell的个数*/
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.hasInput?self.data.count+1:self.data.count;
}

/** cell的内容*/
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.data.count) {
        FYSelectItemCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFYSelectItemCollectionCellID forIndexPath:indexPath];
        NSDictionary *dic = self.data[indexPath.row];
        cell.label.text = [dic objectForKey:@"name"];
        [cell refreshViewWithSelected:[self.selectIndexPathArray containsObject:indexPath]];
        return cell;
    }else if(indexPath.row == self.data.count) {
        FYRangeInputCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFYRangeInputCollectionCellID forIndexPath:indexPath];
        __weak typeof(self)weakSelf = self;
        cell.valueChangeBlock = ^{
            for (NSIndexPath *indexPath in weakSelf.collectionView.indexPathsForSelectedItems) {
                [collectionView deselectItemAtIndexPath:indexPath animated:NO];
                if (indexPath.row < weakSelf.data.count) {
                    FYSelectItemCollectionCell *cell = (FYSelectItemCollectionCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                    [cell refreshViewWithSelected:NO];
                }
            }
            weakSelf.bInput = YES;
            return YES;
        };
        self.rangeInputCell = cell;
        if (self.bInput && ![NSString isEmpty:self.selectItemName]) {
            NSArray *array = [self.selectItemName componentsSeparatedByString:@"-"];
            if (array && array.count>0) {
                cell.minTextField.text = array[0];
                if (array.count>1) {
                    cell.maxTextField.text = array[1];
                }
            }
        }else {
           cell.minTextField.text = @"";
           cell.maxTextField.text = @"";
        }
        [cell refreshView];
        return cell;
    }
    return nil;
}

/** 总共多少组*/
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row < self.data.count) {
        FYSelectItemCollectionCell *cell = (FYSelectItemCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
        if ([self.selectIndexPathArray containsObject:indexPath]) {  //已选中的情况下，再次点击则反选
            if (!(self.mustInput && self.selectIndexPathArray.count == 1)) {  //如果必选时，最后只剩下一项时，不可反选
                [cell refreshViewWithSelected:NO];
                if ([self.selectIndexPathArray containsObject:indexPath]) {
                    [self.selectIndexPathArray removeObject:indexPath];
                }
            }
        }else {
            if (!self.multiple) {
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
        
        NSDictionary *dic = self.data[indexPath.row];
        self.selectItemName = [dic objectForKey:@"name"];
        self.rangeInputCell.minTextField.text = @"";
        self.rangeInputCell.maxTextField.text = @"";
        [self.rangeInputCell refreshView];
        self.bInput = NO;
    }
    if (self.confirmButton.hidden) {  //确认按钮 隐藏时，点击直接确认选择
        NSString *result = @"";
        for (NSIndexPath *indexPath in self.selectIndexPathArray) {
            if (indexPath.row < self.data.count) {
                NSDictionary *dic = self.data[indexPath.row];
                result = [dic objectForKey:@"name"];
            }
        }
        if ([self.delegate respondsToSelector:@selector(rangeSelectAndInputViewWithTitle:result:)]) {
            [self.delegate rangeSelectAndInputViewWithTitle:self.title result:result];
        }
    }
}

- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemWidth = [self defaultWidth];
    if (indexPath.row < self.data.count) {
        NSDictionary *dic = self.data[indexPath.row];
        NSString *title = [dic objectForKey:@"name"];
        CGFloat titleLength = [title stringLengthWithFont:[UIFont systemFontOfSize:13]];
        NSInteger usageItemCount = [self usageItemCountWithTitleLength:titleLength];
        itemWidth = usageItemCount*itemWidth + (usageItemCount-1)*kItemSpacing;
    }else if (indexPath.row == self.data.count) {
        itemWidth = [self defaultWidth]*2 + 8;
    }
    return CGSizeMake(itemWidth, kItemHeight);
}


- (void)clickConfirmButton:(UIButton *)sender {
    NSString *result = @"";
    if (!self.multiple) {
        for (NSIndexPath *indexPath in self.selectIndexPathArray) {
            if (indexPath.row < self.data.count) {
                NSDictionary *dic = self.data[indexPath.row];
                result = [dic objectForKey:@"name"];
            }
        }
    }else {
        //排序
        [self.selectIndexPathArray sortUsingComparator:^NSComparisonResult(NSIndexPath  *obj1, NSIndexPath *obj2) {
            return [obj1 compare:obj2];
        }];
        NSMutableArray *nameList = [[NSMutableArray alloc] init];
        for (NSIndexPath *indexPath in self.selectIndexPathArray) {
            if (indexPath.row < self.data.count) {
                NSDictionary *dic = self.data[indexPath.row];
                [nameList addObject:[dic objectForKey:@"name"]];
            }
        }
        result = [nameList componentsJoinedByString:@","];
    }
    
    if ([NSString isEmpty:result] && self.hasInput) {
        FYRangeInputCollectionCell *cell = (FYRangeInputCollectionCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:self.data.count inSection:0]];
        if (![NSString isEmpty:cell.minTextField.text] && ![NSString isEmpty:cell.maxTextField.text]) {
            if ([cell.maxTextField.text integerValue] >= [cell.minTextField.text integerValue]) {
                result = [NSString stringWithFormat:@"%@-%@",cell.minTextField.text,cell.maxTextField.text];
            }else {
                [FYProgressHUD showToastStatus:@"请输入正确的内容"];
            }
        }
    }
    
    if ([NSString isEmpty:result]) {
        if (self.mustInput) {
            [FYProgressHUD showToastStatus:[NSString stringWithFormat:@"%@",self.hasInput?@"请选择或输入正确的内容":@"请选择一项内容"]];
            return;
        }else {
            result = @"";
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(rangeSelectAndInputViewWithTitle:result:)]) {
        [self.delegate rangeSelectAndInputViewWithTitle:self.title result:result];
    }
}


- (void)createDefaultView {
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.backgroundColor = color_gray_f6f6f6;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = [UIFont systemFontOfSize:18];
    self.titleLabel.textColor = color_black6;
    [self addSubview:self.titleLabel];
    
    self.confirmButton = [[UIButton alloc] init];
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:color_blue_00a0e9 forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(clickConfirmButton:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.confirmButton];
    self.confirmButton.hidden = !self.multiple;
    self.lineView = [[UIView alloc] init];
    self.lineView.backgroundColor = color_line;
    [self addSubview:self.lineView];
    
    FYCollectionViewFlowLayout *layout = [[FYCollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake([self defaultWidth], kItemHeight);
    layout.minimumInteritemSpacing = kItemSpacing;
    layout.minimumLineSpacing = kLineSpacing;
    layout.sectionInset = UIEdgeInsetsMake(16,16,16,16);
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 45, ScreenWidth, 355) collectionViewLayout:layout];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FYSelectItemCollectionCell" bundle:nil]  forCellWithReuseIdentifier:kFYSelectItemCollectionCellID];
    [self.collectionView registerNib:[UINib nibWithNibName:@"FYRangeInputCollectionCell" bundle:nil]  forCellWithReuseIdentifier:kFYRangeInputCollectionCellID];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView setBackgroundColor:color_white];
    
    [self addSubview:self.collectionView];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@44);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.mas_top);
        make.height.equalTo(@44);
        make.width.equalTo(@65);
    }];
    [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.titleLabel.mas_bottom);
        make.height.equalTo(@0.5);
    }];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(self.lineView.mas_bottom);
        make.bottom.equalTo(self.mas_bottom);
    }];
    self.selectIndexPathArray = [[NSMutableArray alloc] init];
}

- (CGFloat)defaultWidth {
    return floorf((ScreenWidth-24-32)/4.0);
}

//根据titleLength宽度，计算占用item数量 最多占用四个
- (NSInteger)usageItemCountWithTitleLength:(CGFloat)titleLength {
    CGFloat itemWidth = [self defaultWidth];
    //左右留三个像素
    titleLength += 6;
    if (itemWidth > titleLength ) {
        return 1;
    }
    if (itemWidth*2 + kItemSpacing > titleLength) {
        return 2;
    }
    if (itemWidth*3 + kItemSpacing*2 > titleLength) {
        return 3;
    }
    return 4;
}

@end
