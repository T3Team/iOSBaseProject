//
//  FYPhotoBrowserCollectionViewCell.m
//  Pods
//
//  Created by marcus on 2017/8/17.
//
//

#import "FYPhotoBrowserCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "FrameAccessor.h"
#import "FYHeader.h"

@interface FYPhotoBrowserCollectionViewCell()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation FYPhotoBrowserCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollView];
        [self.scrollView addSubview:self.imageView];
        [self addLongGesture];
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
    }
    return self;
}

#pragma mark --getter setter
- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, 0, self.width, self.height);
        _scrollView.maximumZoomScale = 3.0;
        _scrollView.minimumZoomScale = 1.0;
        _scrollView.multipleTouchEnabled = YES;
        _scrollView.delegate = self;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _scrollView.delaysContentTouches = NO;
    }
    return _scrollView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.scrollView.frame];
        _imageView.contentMode = UIViewContentModeScaleToFill;
    }
    return _imageView;
}

-(void) addLongGesture{
    //初始化一个长按手势
    UILongPressGestureRecognizer *longPressGest = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressView:)];
    
    //长按等待时间
    longPressGest.minimumPressDuration = 2;
    
    //长按时候,手指头可以移动的距离
    longPressGest.allowableMovement = 30;
    [self.imageView addGestureRecognizer:longPressGest];
    
}

-(void)longPressView:(UILongPressGestureRecognizer *)sender{
    FYLog(@"长按保存");
}



- (void)setImageModel:(FYImageModel *)imageModel{
    _imageModel = imageModel;
    if (imageModel.urlString) {
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.urlString] placeholderImage:[UIImage imageNamed:@""]];
        __weak typeof(self) weakSelf = self;
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageModel.urlString] placeholderImage:[UIImage imageNamed:@""] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image) {
                weakSelf.imageModel.size = image.size;
                [weakSelf _resizeImage];
            }
        }];
    } else {
        self.imageView.image = [UIImage imageWithContentsOfFile:imageModel.localPath];
        if (self.imageView.image) {
            self.imageModel.size = self.imageView.image.size;
            [self _resizeImage];
        }
    }
    
}
#pragma mark --public
- (void)resetScale{
    self.scrollView.zoomScale = 1.;
    self.scrollView.contentSize = self.bounds.size;
    [self _resizeImage];
}

- (void)_resizeImage{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 10;
    CGFloat height = 0;
    if (self.imageModel.size.width == 0) {
        height = ScreenHeight - NavigationHeight- TabBarHeight;
    }else {
        height = width * (self.imageModel.size.height / self.imageModel.size.width);
    }
    self.imageView.height = height;
    self.imageView.width = width;
    self.imageView.center = self.scrollView.center;
}

#pragma mark - 手势点击事件
- (void)doubleTapAction:(UITapGestureRecognizer *)tap
{
    UIScrollView *scrollView = self.scrollView;
    
    CGFloat scale = 1;
    if (scrollView.zoomScale != 3.0) {
        scale = 3;
    } else {
        scale = 1;
    }
    CGRect zoomRect = [self zoomRectForScale:scale withCenter:[tap locationInView:tap.view]];
    [scrollView zoomToRect:zoomRect animated:YES];
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.scrollView.frame.size.height / scale;
    zoomRect.size.width  = self.scrollView.frame.size.width  / scale;
    zoomRect.origin.x    = center.x - (zoomRect.size.width  /2.0);
    zoomRect.origin.y    = center.y - (zoomRect.size.height /2.0);
    return zoomRect;
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return scrollView.subviews[0];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ? (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ? (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY);
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = width * (self.imageModel.size.height / self.imageModel.size.width);
    scrollView.contentSize = CGSizeMake(width * scrollView.zoomScale,
                                        height * scrollView.zoomScale);
}


@end
