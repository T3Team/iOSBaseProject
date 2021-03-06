//
//  ZLShowBigImgViewController.m
//  多选相册照片
//
//  Created by long on 15/11/25.
//  Copyright © 2015年 long. All rights reserved.
//

#import "ZLShowBigImgViewController.h"
#import <Photos/Photos.h>
#import "ZLBigImageCell.h"
#import "ZLDefine.h"
#import "ToastUtils.h"
#import "ZLPhotoBrowser.h"
#import "ZLPhotoModel.h"
#import "ZLPhotoManager.h"
#import "ZLEditViewController.h"
#import "UIButton+EnlargeTouchArea.h"


@interface ZLShowBigImgViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
{
    UICollectionView *_collectionView;
    
    UIButton *_navRightBtn;
    
    //底部view
    UIView   *_bottomView;
    UIButton *_btnOriginalPhoto;
    UIButton *_btnDone;
    //编辑按钮
    UIButton *_btnEdit;
    
    //双击的scrollView
    UIScrollView *_selectScrollView;
    NSInteger _currentPage;
    
    NSArray *_arrSelPhotosBackup;
    NSMutableArray *_arrSelAssets;
    NSArray *_arrSelAssetsBackup;
    
    BOOL _isFirstAppear;
}

@property (nonatomic, strong) UILabel *labPhotosBytes;

@end

@implementation ZLShowBigImgViewController

- (void)dealloc
{
//    NSLog(@"---- %s", __FUNCTION__);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;

    _isFirstAppear = YES;
    _currentPage = self.selectIndex+1;
    self.title = [NSString stringWithFormat:@"%d/%ld", 0, self.models.count];
    [self initNavBtns];
    [self initCollectionView];
    [self initBottomView];
    [self resetDontBtnState];
    [self resetEditBtnState];
    [self resetOriginalBtnState];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!_isFirstAppear) {
        return;
    }
    
    [_collectionView setContentOffset:CGPointMake(self.selectIndex*(kViewWidth+kItemMargin), 0)];
    
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (!_isFirstAppear) {
        return;
    }
    _isFirstAppear = NO;
    [self reloadCurrentCell];
}

- (void)setModels:(NSArray<ZLPhotoModel *> *)models
{
    _models = models;
    if (self.arrSelPhotos) {
        _arrSelAssets = [NSMutableArray array];
        for (ZLPhotoModel *m in models) {
            [_arrSelAssets addObject:m.asset];
        }
        _arrSelAssetsBackup = _arrSelAssets.copy;
    }
}

- (void)setArrSelPhotos:(NSMutableArray<UIImage *> *)arrSelPhotos
{
    _arrSelPhotos = arrSelPhotos;
    _arrSelPhotosBackup = arrSelPhotos.copy;
}

- (void)initNavBtns
{
    //left nav btn
    UIImage *navBackImg = GetImageWithName(@"navBackBtn.png");
                           
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[navBackImg imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(btnBack_Click)];
    
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (!nav.showSelectBtn) {
        return;
    }
    
    //right nav btn
    _navRightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _navRightBtn.frame = CGRectMake(ScreenWidth-23-12, NavigationHeight-12-23, 23, 23);
    UIImage *normalImg = [UIImage imageNamed:@"icon_right_circle.png"];
    UIImage *selImg = [UIImage imageNamed:@"icon_right_select.png"];
    [_navRightBtn setBackgroundImage:normalImg forState:UIControlStateNormal];
    [_navRightBtn setBackgroundImage:selImg forState:UIControlStateSelected];
    [_navRightBtn setEnlargeEdgeWithTop:10 right:0 bottom:10 left:20];

    [_navRightBtn addTarget:self action:@selector(navRightBtn_Click:) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_navRightBtn];
    [self.navigationBar addSubview:_navRightBtn];
    
    if (self.models.count == 1) {
        _navRightBtn.selected = self.models.firstObject.isSelected;
    }
    ZLPhotoModel *model = self.models[_currentPage-1];
    _navRightBtn.selected = model.isSelected;
}

#pragma mark - 初始化CollectionView
- (void)initCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = kItemMargin;
    layout.sectionInset = UIEdgeInsetsMake(0, kItemMargin/2, 0, kItemMargin/2);
    layout.itemSize = self.view.bounds.size;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(-kItemMargin/2, 0, kViewWidth+kItemMargin, kViewHeight) collectionViewLayout:layout];
    [_collectionView registerClass:[ZLBigImageCell class] forCellWithReuseIdentifier:@"ZLBigImageCell"];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.pagingEnabled = YES;
    [self.view addSubview:_collectionView];
}

- (void)initBottomView
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, kViewWidth, 49)];
    _bottomView.clipsToBounds = YES;
    _bottomView.backgroundColor = color_white;
    
    _btnOriginalPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnOriWidth = GetMatchValue(GetLocalLanguageTextValue(ZLPhotoBrowserOriginalText), 15, YES, 30);
    _btnOriginalPhoto.frame = CGRectMake(12, 7, btnOriWidth+25, 30);
    [_btnOriginalPhoto setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserOriginalText) forState:UIControlStateNormal];
    _btnOriginalPhoto.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnOriginalPhoto setTitleColor:kDoneButton_bgColor forState: UIControlStateNormal];
    UIImage *normalImg = GetImageWithName(@"btn_original_circle.png");
    UIImage *selImg = GetImageWithName(@"btn_selected.png");
    [_btnOriginalPhoto setImage:normalImg forState:UIControlStateNormal];
    [_btnOriginalPhoto setImage:selImg forState:UIControlStateSelected];
    [_btnOriginalPhoto setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 5)];
    [_btnOriginalPhoto addTarget:self action:@selector(btnOriginalImage_Click:) forControlEvents:UIControlEventTouchUpInside];
    _btnOriginalPhoto.selected = nav.isSelectOriginalPhoto;
    [self getPhotosBytes];
//    [_bottomView addSubview:_btnOriginalPhoto];
    
    self.labPhotosBytes = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_btnOriginalPhoto.frame)+5, 7, 80, 30)];
    self.labPhotosBytes.font = [UIFont systemFontOfSize:15];
    self.labPhotosBytes.textColor = kDoneButton_bgColor;
//    [_bottomView addSubview:self.labPhotosBytes];
    
    //编辑
    _btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnEdit.frame = CGRectMake(kViewWidth/2-30, 7, 60, 30);
    [_btnEdit setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserEditText) forState:UIControlStateNormal];
    _btnEdit.titleLabel.font = [UIFont systemFontOfSize:15];
    [_btnEdit setTitleColor:kDoneButton_bgColor forState:UIControlStateNormal];
    [_btnEdit addTarget:self action:@selector(btnEdit_Click:) forControlEvents:UIControlEventTouchUpInside];
//    [_bottomView addSubview:_btnEdit];
    
    _btnDone = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnDone.frame = CGRectMake(kViewWidth - 108, 7, 91, 35);
    [_btnDone setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserDoneText) forState:UIControlStateNormal];
    _btnDone.titleLabel.font = [UIFont systemFontOfSize:16];
    _btnDone.layer.masksToBounds = YES;
    _btnDone.layer.cornerRadius = 5.0f;
    [_btnDone setTitleColor:color_red_e8382b forState:UIControlStateNormal];
    [_btnDone setBackgroundColor:color_white];
    [_btnDone.layer setBorderWidth:1.0];
    [_btnDone.layer setBorderColor:color_red_e8382b.CGColor];
    [_btnDone addTarget:self action:@selector(btnDone_Click:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:_btnDone];
    
    [self.view addSubview:_bottomView];
    
    if (self.arrSelPhotos) {
        //预览用户已确定选择的照片，隐藏原图按钮
        _btnOriginalPhoto.hidden = YES;
    }
    if (!nav.allowEditImage) {
        _btnEdit.hidden = YES;
    }
}

#pragma mark - UIButton Actions
- (void)btnOriginalImage_Click:(UIButton *)btn
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    nav.isSelectOriginalPhoto = btn.selected = !btn.selected;
    if (btn.selected) {
        [self getPhotosBytes];
        if (!_navRightBtn.isSelected) {
            if (nav.showSelectBtn &&
                nav.arrSelectedModels.count < nav.maxSelectCount) {
                [self navRightBtn_Click:_navRightBtn];
            }
        }
    } else {
        self.labPhotosBytes.text = nil;
    }
}

- (void)btnEdit_Click:(UIButton *)btn
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    BOOL flag = !_navRightBtn.isSelected && nav.showSelectBtn &&
    nav.arrSelectedModels.count < nav.maxSelectCount;
    
    ZLPhotoModel *model = self.models[_currentPage-1];
    if (flag) {
        [self navRightBtn_Click:_navRightBtn];
        if (![ZLPhotoManager judgeAssetisInLocalAblum:model.asset]) {
            return;
        }
    }
    
    ZLEditViewController *vc = [[ZLEditViewController alloc] init];
    vc.model = model;
    ZLBigImageCell *cell = (ZLBigImageCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage-1 inSection:0]];
    vc.oriImage = cell.previewView.image;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void)btnDone_Click:(UIButton *)btn
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (nav.arrSelectedModels.count == 0) {
        ZLPhotoModel *model = self.models[_currentPage-1];
        if (![ZLPhotoManager judgeAssetisInLocalAblum:model.asset]) {
            ShowToastLong(@"%@", GetLocalLanguageTextValue(ZLPhotoBrowserLoadingText));
            return;
        }
        if (model.type == ZLAssetMediaTypeVideo && GetDuration(model.duration) > nav.maxVideoDuration) {
            ShowToastLong(GetLocalLanguageTextValue(ZLPhotoBrowserMaxVideoDurationText), nav.maxVideoDuration);
            return;
        }
        
        [nav.arrSelectedModels addObject:model];
    }
    if (self.arrSelPhotos && self.btnDonePreviewBlock) {
        self.btnDonePreviewBlock(self.arrSelPhotos, _arrSelAssets);
    } else if (nav.callSelectImageBlock) {
        nav.callSelectImageBlock();
    }
}

- (void)backButtonAction {
    [self btnBack_Click];
}

- (void)btnBack_Click
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (self.btnBackBlock) {
        self.btnBackBlock(nav.arrSelectedModels, nav.isSelectOriginalPhoto);
    }
    
    UIViewController *vc = [self.navigationController popViewControllerAnimated:YES];
    //由于collectionView的frame的width是大于该界面的width，所以设置这个颜色是为了pop时候隐藏collectionView的黑色背景
    _collectionView.backgroundColor = [UIColor clearColor];
    if (!vc) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)navRightBtn_Click:(UIButton *)btn
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    
    ZLPhotoModel *model = self.models[_currentPage-1];
    if (!btn.selected) {
        //选中
        [btn.layer addAnimation:GetBtnStatusChangedAnimation() forKey:nil];
        if (nav.arrSelectedModels.count >= nav.maxSelectCount) {
            ShowToastLong(GetLocalLanguageTextValue(ZLPhotoBrowserMaxSelectCountText), nav.maxSelectCount);
            return;
        }
        if (![ZLPhotoManager judgeAssetisInLocalAblum:model.asset]) {
            ShowToastLong(@"%@", GetLocalLanguageTextValue(ZLPhotoBrowserLoadingText));
            return;
        }
        if (model.type == ZLAssetMediaTypeVideo && GetDuration(model.duration) > nav.maxVideoDuration) {
            ShowToastLong(GetLocalLanguageTextValue(ZLPhotoBrowserMaxVideoDurationText), nav.maxVideoDuration);
            return;
        }
        
        model.isSelected = YES;
        [nav.arrSelectedModels addObject:model];
        if (self.arrSelPhotos) {
            [self.arrSelPhotos addObject:_arrSelPhotosBackup[_currentPage-1]];
            [_arrSelAssets addObject:_arrSelAssetsBackup[_currentPage-1]];
        }
    } else {
        //移除
        model.isSelected = NO;
        for (ZLPhotoModel *m in nav.arrSelectedModels) {
            if ([m.asset.localIdentifier isEqualToString:model.asset.localIdentifier]) {
                [nav.arrSelectedModels removeObject:m];
                break;
            }
        }
        if (self.arrSelPhotos) {
            for (PHAsset *asset in _arrSelAssets) {
                if ([asset isEqual:_arrSelAssetsBackup[_currentPage-1]]) {
                    [_arrSelAssets removeObject:asset];
                    break;
                }
            }
            [self.arrSelPhotos removeObject:_arrSelPhotosBackup[_currentPage-1]];
        }
    }
    
    btn.selected = !btn.selected;
    [self getPhotosBytes];
    [self resetDontBtnState];
    [self resetEditBtnState];
}

#pragma mark - 更新按钮、导航条等显示状态
- (void)resetDontBtnState
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (nav.arrSelectedModels.count > 0) {
        [_btnDone setTitle:[NSString stringWithFormat:@"%@ (%ld)", GetLocalLanguageTextValue(ZLPhotoBrowserDoneText), nav.arrSelectedModels.count] forState:UIControlStateNormal];
        self.title = [NSString stringWithFormat:@"%ld/%ld", nav.arrSelectedModels.count, self.models.count];
        [self.navigationBar updateTitle:self.title];
    } else {
        [_btnDone setTitle:GetLocalLanguageTextValue(ZLPhotoBrowserDoneText) forState:UIControlStateNormal];
    }
}

- (void)resetEditBtnState
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (!nav.allowEditImage) return;

    ZLPhotoModel *m = self.models[_currentPage-1];
    BOOL flag = [m.asset.localIdentifier isEqualToString:nav.arrSelectedModels.firstObject.asset.localIdentifier];
    
    if (((m.type == ZLAssetMediaTypeImage) ||
         (m.type == ZLAssetMediaTypeGif && !nav.allowSelectGif) ||
         (m.type == ZLAssetMediaTypeLivePhoto && !nav.allowSelectLivePhoto)) &&
        (nav.arrSelectedModels.count == 0 ||
         (nav.arrSelectedModels.count <= 1 && flag))) {
        _btnEdit.hidden = NO;
    } else {
        _btnEdit.hidden = YES;
    }
}

- (void)resetOriginalBtnState
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    ZLPhotoModel *m = self.models[_currentPage-1];
    if ((m.type == ZLAssetMediaTypeImage) ||
         (m.type == ZLAssetMediaTypeGif && !nav.allowSelectGif) ||
         (m.type == ZLAssetMediaTypeLivePhoto && !nav.allowSelectLivePhoto)) {
            _btnOriginalPhoto.hidden = NO;
            self.labPhotosBytes.hidden = NO;
        } else {
            _btnOriginalPhoto.hidden = YES;
            self.labPhotosBytes.hidden = YES;
        }
}

- (void)getPhotosBytes
{
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (!nav.isSelectOriginalPhoto) return;
    
    NSArray *arr = nav.showSelectBtn?nav.arrSelectedModels:@[self.models[_currentPage-1]];
    
    if (arr.count) {
        weakify(self);
        [ZLPhotoManager getPhotosBytesWithArray:arr completion:^(NSString *photosBytes) {
            strongify(weakSelf);
            strongSelf.labPhotosBytes.text = [NSString stringWithFormat:@"(%@)", photosBytes];
        }];
    } else {
        self.labPhotosBytes.text = nil;
    }
}

- (void)showNavBarAndBottomView
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
    CGRect frame = _bottomView.frame;
    frame.origin.y -= frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.frame = frame;
    }];
}

- (void)hideNavBarAndBottomView
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    CGRect frame = _bottomView.frame;
    frame.origin.y += frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _bottomView.frame = frame;
    }];
}


#pragma mark - UICollectionDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.models.count;
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [((ZLBigImageCell *)cell).previewView resetScale];
    ((ZLBigImageCell *)cell).willDisplaying = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [((ZLBigImageCell *)cell).previewView handlerEndDisplaying];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ZLBigImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZLBigImageCell" forIndexPath:indexPath];
    ZLPhotoModel *model = self.models[indexPath.row];
    
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    
    cell.showGif = nav.allowSelectGif;
    cell.showLivePhoto = nav.allowSelectLivePhoto;
    cell.model = model;
//    weakify(self);
//    cell.singleTapCallBack = ^() {
//        strongify(weakSelf);
//        if (strongSelf.navigationController.navigationBar.isHidden) {
//            [strongSelf showNavBarAndBottomView];
//        } else {
//            [strongSelf hideNavBarAndBottomView];
//        }
//    };
    
    return cell;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == (UIScrollView *)_collectionView) {
        ZLPhotoModel *m = [self getCurrentPageModel];
        if (!m) return;
        //改变导航标题
        self.title = [NSString stringWithFormat:@"%ld/%ld", _currentPage, self.models.count];
        
        _navRightBtn.selected = m.isSelected;
        
        [self resetOriginalBtnState];
        [self resetEditBtnState];
        
        if (m.type == ZLAssetMediaTypeGif ||
            m.type == ZLAssetMediaTypeLivePhoto ||
            m.type == ZLAssetMediaTypeVideo) {
            ZLBigImageCell *cell = (ZLBigImageCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage-1 inSection:0]];
            [cell pausePlay];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //单选模式下获取当前图片大小
    ZLImageNavigationController *nav = (ZLImageNavigationController *)self.navigationController;
    if (!nav.showSelectBtn) [self getPhotosBytes];
    
    [self reloadCurrentCell];
}

- (void)reloadCurrentCell
{
    ZLPhotoModel *m = [self getCurrentPageModel];
    if (m.type == ZLAssetMediaTypeGif ||
        m.type == ZLAssetMediaTypeLivePhoto ||
        m.type == ZLAssetMediaTypeVideo) {
        ZLBigImageCell *cell = (ZLBigImageCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPage-1 inSection:0]];
        [cell reloadGifLivePhoto];
    }
}

- (ZLPhotoModel *)getCurrentPageModel
{
    CGPoint offset = _collectionView.contentOffset;
    if (offset.x < .0 || offset.x > (_collectionView.contentSize.width-kViewWidth-kItemMargin)) {
        return nil;
    }
    CGFloat page = _collectionView.contentOffset.x/(kViewWidth+kItemMargin);
    NSString *str = [NSString stringWithFormat:@"%.0f", page];
    _currentPage = str.integerValue + 1;
    ZLPhotoModel *model = self.models[_currentPage-1];
    return model;
}

@end
