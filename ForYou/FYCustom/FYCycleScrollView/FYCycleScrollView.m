//
//  FYCycleScrollView.m
//  ForYou
//
//  Created by marcus on 2017/8/11.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYCycleScrollView.h"
#import "FYCycleScrollViewCell.h"
#import "FYHeader.h"

@interface FYCycleScrollView() <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, weak) UICollectionView *mainView; // 显示图片的collectionView
@property (nonatomic, weak) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) NSArray *imagePathsGroup;
@property (nonatomic, weak) NSTimer *timer;
@property (nonatomic, assign) NSInteger totalItemsCount;
@property (nonatomic, weak) UIControl *pageControl;
@property (nonatomic, strong) UILabel *pageLabel;    //显示当前页数

@property (nonatomic, strong) UIImageView *backgroundImageView; // 当imageURLs为空时的背景图

@property (nonatomic, weak) id<FYCycleScrollViewDelegate> delegate;
@property (nonatomic, strong) UIImage *placeholderImage;
@property (nonatomic, strong) UIColor *titleLabelTextColor;  //轮播文字label字体颜色
@property (nonatomic, strong) UIFont  *titleLabelTextFont;  //轮播文字label字体大小
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;  //轮播文字label背景颜色
@property (nonatomic, assign) CGFloat titleLabelHeight; //轮播文字label高度
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment; //轮播文字label对齐方式
@end

static NSString *kFYCycleScrollViewCellID = @"FYCycleScrollViewCellID";

@implementation FYCycleScrollView

+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<FYCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage
{
    FYCycleScrollView *cycleScrollView = [[self alloc] initWithFrame:frame];
    cycleScrollView.delegate = delegate;
    cycleScrollView.placeholderImage = placeholderImage;
    
    return cycleScrollView;
}

#pragma mark - life circles

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
        [self setupMainView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialization];
    [self setupMainView];
}

- (void)initialization
{
    _autoScrollTimeInterval = 2.0;
    _autoScroll = YES;
    _infiniteLoop = YES;
    _hidesForSinglePage = YES;
    _titleLabelTextColor = [UIColor whiteColor];
    _titleLabelTextFont= [UIFont systemFontOfSize:14];
    _titleLabelBackgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    _titleLabelHeight = 30;
    _titleLabelTextAlignment = NSTextAlignmentLeft;
    _bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    _horizontalMargins = 0;
    _pageControlStyle = FYCycleScrollViewPageControlStyleLabel;
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    self.delegate = self.delegate;
    
    [super layoutSubviews];
    
    _flowLayout.itemSize = self.frame.size;
    
    _mainView.frame = self.bounds;
    if (_mainView.contentOffset.x == 0 &&  _totalItemsCount) {
        int targetIndex = 1;
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
    
    CGSize size = CGSizeZero;
    
    size = CGSizeMake(self.imagePathsGroup.count * 15.0, 10.0);
    CGFloat x = (self.fy_width - size.width) * 0.5;
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(x);
        make.width.equalTo(@(size.width));
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@(size.height));
        
    }];
    self.pageControl.hidden = !(self.pageControlStyle == FYCycleScrollViewPageControlStyleOrigin);
    self.pageLabel.hidden = !(self.pageControlStyle == FYCycleScrollViewPageControlStyleLabel);
    if (self.pageControlStyle == FYCycleScrollViewPageControlStyleLabel) {
        if ((self.imagePathsGroup.count == 1) && self.hidesForSinglePage) {
            self.pageLabel.hidden = YES;
        }else {
            self.pageLabel.hidden = NO;
        }
    }
    if (self.backgroundImageView) {
        self.backgroundImageView.frame = self.bounds;
        [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.top.equalTo(self.mas_top);
            make.bottom.equalTo(self.mas_bottom);
        }];
    }
    
    if (!(self.startIndex==0) && _totalItemsCount > self.startIndex) {
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:self.startIndex+1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

// 设置显示图片的collectionView
- (void)setupMainView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _flowLayout = flowLayout;
    
    UICollectionView *mainView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
    mainView.backgroundColor = [UIColor clearColor];
    mainView.pagingEnabled = YES;
    mainView.showsHorizontalScrollIndicator = NO;
    mainView.showsVerticalScrollIndicator = NO;
    [mainView registerClass:[FYCycleScrollViewCell class] forCellWithReuseIdentifier:kFYCycleScrollViewCellID];
    
    mainView.dataSource = self;
    mainView.delegate = self;
    mainView.scrollsToTop = NO;
    [self addSubview:mainView];
    _mainView = mainView;
}

#pragma mark -private methods
- (void)setupTimer
{
    [self invalidateTimer]; // 创建定时器前先停止定时器，不然会出现僵尸定时器，导致轮播频率错误
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer
{
    [_timer invalidate];
    _timer = nil;
}

- (void)automaticScroll
{
    if (0 == _totalItemsCount) return;
    int currentIndex = [self currentIndex];
    int targetIndex = currentIndex + 1;
    [self scrollToIndex:targetIndex animated:YES];
}

- (void)scrollToIndex:(int)targetIndex animated:(BOOL)animated
{
    if (targetIndex <= _totalItemsCount-1) {
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:targetIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    }
}

- (int)currentIndex
{
    if (_mainView.fy_width == 0 || _mainView.fy_height == 0) {
        return 0;
    }
    
    int index = 0;
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        index = (_mainView.contentOffset.x + _flowLayout.itemSize.width * 0.5) / _flowLayout.itemSize.width;
    } else {
        index = (_mainView.contentOffset.y + _flowLayout.itemSize.height * 0.5) / _flowLayout.itemSize.height;
    }
    
    return MAX(0, index);
}

- (int)pageControlIndexWithCurrentCellIndex:(NSInteger)index
{
    int currentIndex = 0;
    if (index == 0) {
        currentIndex = (int)self.imagePathsGroup.count-1;
    }else if (index == self.imagePathsGroup.count+1) {
        currentIndex = 0;
    }else {
        currentIndex = (int)index - 1;
    }
    
    return currentIndex;
}

- (void)setupPageControl
{
    if (_pageControl) [_pageControl removeFromSuperview]; // 重新加载数据时调整
    
    if (self.imagePathsGroup.count == 0 || self.onlyDisplayText) return;
    if ((self.imagePathsGroup.count == 1) && self.hidesForSinglePage) return;
    if (self.hidePageControl) return;
    
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:[self currentIndex]];
    
    if (self.pageControlStyle == FYCycleScrollViewPageControlStyleOrigin) { //显示原点时
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        pageControl.numberOfPages = self.imagePathsGroup.count;
        pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];;
        pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        pageControl.userInteractionEnabled = NO;
        pageControl.currentPage = indexOnPageControl;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }else {
        if (!self.pageLabel) {
            self.pageLabel = [[UILabel alloc]init];
            self.pageLabel.textAlignment = NSTextAlignmentCenter;
            self.pageLabel.backgroundColor = color_background_opaque;
            self.pageLabel.textColor = color_white;
            [self.pageLabel.layer setCornerRadius:10.0];
            [self.pageLabel setClipsToBounds:YES];
            self.pageLabel.font = [UIFont systemFontOfSize:14];
            self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld",indexOnPageControl+1,self.imagePathsGroup.count];
            [self addSubview:self.pageLabel];
            [self.pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self).offset((ScreenWidth-50)/2.0);
                make.width.greaterThanOrEqualTo(@50.0);
                make.bottom.equalTo(self).offset(-10);
                make.height.equalTo(@20.0);
            }];
        }else{
            self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld",indexOnPageControl+1,self.imagePathsGroup.count];
        }
    }
}

//解决当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!newSuperview) {
        [self invalidateTimer];
    }
}

//解决当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainView.delegate = nil;
    _mainView.dataSource = nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _totalItemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FYCycleScrollViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kFYCycleScrollViewCellID forIndexPath:indexPath];
    cell.horizontalMargins = self.horizontalMargins;
    long itemIndex = [self pageControlIndexWithCurrentCellIndex:indexPath.item];
    
    NSString *imagePath = self.imagePathsGroup[itemIndex];
    
    if (!self.onlyDisplayText && [imagePath isKindOfClass:[NSString class]]) {
        if ([imagePath containsString:@"http"]) {
            [cell.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:self.placeholderImage];
        } else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                [UIImage imageWithContentsOfFile:imagePath];
            }
            cell.imageView.image = image;
        }
    } else if (!self.onlyDisplayText && [imagePath isKindOfClass:[UIImage class]]) {
        cell.imageView.image = (UIImage *)imagePath;
    }
    
    if (_titlesGroup && _titlesGroup.count>0) {
        if (itemIndex < _titlesGroup.count) {
            cell.title = _titlesGroup[itemIndex];
        }else {
            cell.title = @"";
        }
    }
    
    if (!cell.hasConfigured) {
        cell.titleLabelBackgroundColor = self.titleLabelBackgroundColor;
        cell.titleLabelHeight = self.titleLabelHeight;
        cell.titleLabelTextAlignment = self.titleLabelTextAlignment;
        cell.titleLabelTextColor = self.titleLabelTextColor;
        cell.titleLabelTextFont = self.titleLabelTextFont;
        cell.hasConfigured = YES;
        cell.imageView.contentMode = self.bannerImageViewContentMode;
        cell.clipsToBounds = YES;
        cell.onlyDisplayText = self.onlyDisplayText;
    }
    
    if (self.onlyDisplayText) {
        cell.titleLabelBackgroundColor = [UIColor clearColor];
        cell.titleLabelTextColor = color_black6;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didSelectItemAtIndex:)]) {
        [self.delegate cycleScrollView:self didSelectItemAtIndex:[self pageControlIndexWithCurrentCellIndex:indexPath.item]];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    if (_flowLayout.scrollDirection == UICollectionViewScrollDirectionHorizontal) {
        if (self.mainView.contentOffset.x <=0 || self.mainView.contentOffset.x >= _flowLayout.itemSize.width*(_totalItemsCount-1)) {
            if (itemIndex == 0) {
                itemIndex = (int)_totalItemsCount-2;
            }else {
                itemIndex = 1;
            }
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            return;
        }
    }else {
        if (self.mainView.contentOffset.y <=0 || self.mainView.contentOffset.y >= _flowLayout.itemSize.height*(_totalItemsCount-1)) {
            if (itemIndex == 0) {
                itemIndex = (int)_totalItemsCount-2;
            }else {
                itemIndex = 1;
            }
            [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
            return;
        }
    }
    
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    if (self.pageControlStyle == FYCycleScrollViewPageControlStyleOrigin) {
        UIPageControl *pageControl = (UIPageControl *)_pageControl;
        pageControl.currentPage = indexOnPageControl;
    }else {
        self.pageLabel.text = [NSString stringWithFormat:@"%d/%ld",indexOnPageControl+1,self.imagePathsGroup.count];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self setupTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:self.mainView];
    
    int itemIndex = [self currentIndex];
    if (itemIndex == 0 || itemIndex == _totalItemsCount-1) {
        if (itemIndex == 0) {
            itemIndex = (int)_totalItemsCount-2;
        }else {
            itemIndex = 1;
        }
        [_mainView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        return;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (!self.imagePathsGroup.count) return; // 解决清除timer时偶尔会出现的问题
    int itemIndex = [self currentIndex];
    int indexOnPageControl = [self pageControlIndexWithCurrentCellIndex:itemIndex];
    
    if ([self.delegate respondsToSelector:@selector(cycleScrollView:didScrollToIndex:)]) {
        [self.delegate cycleScrollView:self didScrollToIndex:indexOnPageControl];
    }
}



#pragma mark - getter and setter methods
- (void)setImagePathsGroup:(NSArray *)imagePathsGroup
{
    [self invalidateTimer];
    
    _imagePathsGroup = imagePathsGroup;
    
    _totalItemsCount = self.imagePathsGroup.count + 2;
    
    if (imagePathsGroup.count > 1) { // 由于 !=1 包含count == 0等情况
        self.mainView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        self.mainView.scrollEnabled = NO;
        [self setAutoScroll:NO];
    }
    
    [self setupPageControl];
    [self.mainView reloadData];
}

- (void)setImageURLStringsGroup:(NSArray *)imageURLStringsGroup
{
    _imageURLStringsGroup = imageURLStringsGroup;
    
    NSMutableArray *temp = [NSMutableArray new];
    [_imageURLStringsGroup enumerateObjectsUsingBlock:^(NSString * obj, NSUInteger idx, BOOL * stop) {
        NSString *urlString;
        if ([obj isKindOfClass:[NSString class]]) {
            urlString = obj;
        } else if ([obj isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)obj;
            urlString = [url absoluteString];
        }
        if (urlString) {
            [temp addObject:urlString];
        }
    }];
    self.imagePathsGroup = [temp copy];
}

- (void)setLocalizationImageNamesGroup:(NSArray *)localizationImageNamesGroup
{
    _localizationImageNamesGroup = localizationImageNamesGroup;
    self.imagePathsGroup = [localizationImageNamesGroup copy];
}

- (void)setPlaceholderImage:(UIImage *)placeholderImage
{
    _placeholderImage = placeholderImage;
    
    if (!self.backgroundImageView) {
        UIImageView *bgImageView = [UIImageView new];
        bgImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self insertSubview:bgImageView belowSubview:self.mainView];
        self.backgroundImageView = bgImageView;
    }
    
    self.backgroundImageView.image = placeholderImage;
}

- (void)setInfiniteLoop:(BOOL)infiniteLoop
{
    _infiniteLoop = infiniteLoop;
    
    if (self.imagePathsGroup.count) {
        self.imagePathsGroup = self.imagePathsGroup;
    }
}

-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self setupTimer];
    }
}


- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval
{
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

- (void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    
    _flowLayout.scrollDirection = scrollDirection;
}

- (void)setTitlesGroup:(NSArray *)titlesGroup
{
    _titlesGroup = titlesGroup;
    if (self.onlyDisplayText) {
        NSMutableArray *temp = [NSMutableArray new];
        for (int i = 0; i < _titlesGroup.count; i++) {
            [temp addObject:@""];
        }
        self.backgroundColor = [UIColor clearColor];
        self.imageURLStringsGroup = [temp copy];
    }
}

@end
