//
//  FYPhotoBrowseViewController.m
//  Pods
//
//  Created by marcus on 2017/8/11.
//
//

#import "FYPhotoBrowseViewController.h"
#import "UIImageView+WebCache.h"
#import "FYPhotoBrowserCollectionViewCell.h"
#import <FrameAccessor/FrameAccessor.h>

static NSString *kBrowseCellID = @"BrowseCellID";

@interface FYPhotoBrowseViewController ()<UICollectionViewDelegate ,UICollectionViewDataSource>



@property (assign) CGPoint centerPoint;
@property (nonatomic, assign) BOOL hasPinched;
@property (nonatomic, strong) UIButton *gobackButon;

@end

@implementation FYPhotoBrowseViewController
@synthesize currentIndex = _currentIndex;
- (instancetype)init{
    if (self = [super init]) {
//        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self _layoutViews];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)_layoutViews{
    [self.pageTipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-10);
        make.width.equalTo(self.view);
        make.centerX.equalTo(self.view);
    }];
    
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.height.mas_equalTo(NavigationHeight);
    }];
    
    [self.gobackButon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.toolBar.mas_bottom);
        make.left.equalTo(self.toolBar.mas_left);
        make.width.mas_equalTo(51);
        make.height.mas_equalTo(42);
    }];
    
    [self.saveLocalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.toolBar.mas_bottom);
        make.right.equalTo(self.toolBar.mas_right);
        make.width.mas_equalTo(42);
        make.height.mas_equalTo(42);
    }];
    
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.toolBar).offset(-140);
        make.height.mas_equalTo(15);
        make.centerX.equalTo(self.toolBar);
        make.bottom.equalTo(self.toolBar).offset(-15);
    }];
}

#pragma mark --setter getter
- (void)setImageModels:(NSArray<FYImageModel *> *)imageModels{
    _imageModels = imageModels;
    [self.collectionView reloadData];
    
    self.title = [NSString stringWithFormat:@"%d / %ld",1,self.imageModels.count];
}

- (void)setCurrentIndex:(NSInteger)currentIndex{
    _currentIndex = currentIndex;
    self.collectionView.contentOffsetX = currentIndex * self.view.width;
    [self didScrollToIndex:currentIndex];
}

- (void)setTitle:(NSString *)title{
    self.titleLabel.text = title;
}

- (UILabel *)pageTipLabel{
    if(!_pageTipLabel){
        _pageTipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 15)];
        _pageTipLabel.textAlignment = NSTextAlignmentCenter;
        _pageTipLabel.textColor = [UIColor whiteColor];
        [self.view addSubview:_pageTipLabel];
    }
    return _pageTipLabel;
}

- (UIView *)toolBar{
    if ((!_toolBar)) {
        _toolBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NavigationHeight)];
        _toolBar.backgroundColor = color_black_alpha7;
        [self.view addSubview:_toolBar];
    }
    return _toolBar;
}

- (UIButton *)gobackButon {
    if (!_gobackButon) {
        _gobackButon = [UIButton buttonWithType:UIButtonTypeCustom];
        [_gobackButon addTarget:self action:@selector(gobackButonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_gobackButon setImage:image_icon_goback_white forState:UIControlStateNormal];
        [self.toolBar addSubview:_gobackButon];
    }
    return _gobackButon;
}
- (UIButton *)saveLocalBtn {
    if (!_saveLocalBtn) {
        _saveLocalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveLocalBtn.backgroundColor = [UIColor clearColor];
        [_saveLocalBtn addTarget:self action:@selector(saveLocalButonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_saveLocalBtn setImage:[UIImage imageNamed:@"icon_download_36"] forState:UIControlStateNormal];
        [self.toolBar addSubview:_saveLocalBtn];
    }
    return _saveLocalBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:17.0];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.toolBar addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        _layout = [UICollectionViewFlowLayout new];
        _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _layout.itemSize = [UIScreen mainScreen].bounds.size;
        _layout.minimumLineSpacing = .1;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame
                                             collectionViewLayout:_layout];
        _collectionView.maximumZoomScale = 3.;
        _collectionView.minimumZoomScale = .25;
        _collectionView.center = self.view.center;
        _collectionView.pagingEnabled = YES;
        
        
        [_collectionView registerClass:[FYPhotoBrowserCollectionViewCell class]
            forCellWithReuseIdentifier:kBrowseCellID];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.view addSubview:_collectionView];
        [self.view insertSubview:_collectionView belowSubview:self.pageTipLabel];
        self.pageTipLabel.hidden = YES;
    }
    return _collectionView;
}

#pragma mark --handler
- (void)gobackButonClick:(UIButton*)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark ---- 保存图片
- (void)saveLocalButonClick:(UIButton *)btn{
    
    NSInteger index = self.currentIndex ?: 0;
    if (_imageModels.count > index) {
        FYImageModel * imgModel = self.imageModels[index];
        
        if (imgModel.urlString) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                // 处理耗时操作的代码块...
                SDWebImageManager *manager = [SDWebImageManager sharedManager] ;
                [manager downloadImageWithURL:[NSURL URLWithString:imgModel.urlString] options:0 progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    if (image) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //回调或者说是通知主线程刷新，
                            [weakSelf saveImg:image];
                        });
                    }else{
                        [FYProgressHUD showToastStatus:@"保存失败"];
                    }
                }];

            });
        } else {
            UIImage * image = [UIImage imageWithContentsOfFile:imgModel.localPath];
            [self saveImg:image];
        }
    }
}

- (void)saveImg:(UIImage *)image{
    UIImageWriteToSavedPhotosAlbum(image,self,@selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:),nil);
}

- (void)imageSavedToPhotosAlbum:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    
    if(!error) {
        [FYProgressHUD showSuccessWithStatus:@"保存成功"];
    }else{
        [FYProgressHUD showToastStatus:@"保存失败"];
    }
}



#pragma mark delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSInteger numberOfTab = self.imageModels.count;
    return numberOfTab;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FYPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBrowseCellID
                                                                                       forIndexPath:indexPath];
    
    FYImageModel *imageModel = self.imageModels[indexPath.row];
    cell.imageModel = imageModel;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [(FYPhotoBrowserCollectionViewCell *)cell  resetScale];
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // 得到每页宽度
    CGFloat pageWidth = sender.frame.size.width;
    // 根据当前的x坐标和页宽度计算出当前页数
    int currentPage = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    self.title = [NSString stringWithFormat:@"%d / %ld",currentPage + 1,
                              self.imageModels.count];
    self->_currentIndex = currentPage;
    [self didScrollToIndex:currentPage];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)sender{
    
}

- (void)didScrollToIndex:(NSInteger)index {
    
}


@end
