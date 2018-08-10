//
//  FYPhotoBrowseViewController.h
//  Pods
//
//  Created by marcus on 2017/8/11.
//
//

#import "FYImageModel.h"
#import "FYBaseViewController.h"

@class FYPhotoBrowseViewController;

@protocol FYPhotoBrowseVCDelegate <NSObject>

@optional
- (void)onFYPhotoBrowserDidFinishBrowe:(FYPhotoBrowseViewController *) browser;

@end

@interface FYPhotoBrowseViewController : FYBaseViewController{
    @protected
    NSInteger _currentIndex;
    
}

@property (nonatomic ,strong ) UICollectionView *collectionView;
@property (nonatomic ,strong ) UICollectionViewFlowLayout *layout;

@property (nonatomic ,strong) UIView *toolBar;
@property (nonatomic ,strong) UILabel *titleLabel;

@property (nonatomic ,strong ) UILabel *pageTipLabel;

@property (nonatomic ,strong) NSArray<FYImageModel *> *imageModels;

@property (nonatomic ,weak) id<FYPhotoBrowseVCDelegate> delegate;

@property (nonatomic ,assign) NSInteger currentIndex;

@property (nonatomic, strong) UIButton *saveLocalBtn;
/**
 图片滚动后 调用方法  子类可重新该方法
 
 @param index 当前页码
 */
- (void)didScrollToIndex:(NSInteger)index;

@end
