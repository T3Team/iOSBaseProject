//
//  FYPhotoBrowserCollectionViewCell.h
//  Pods
//
//  Created by marcus on 2017/8/17.
//
//

#import <UIKit/UIKit.h>
#import "FYImageModel.h"

@interface FYPhotoBrowserCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) FYImageModel *imageModel;

- (void)resetScale;
@end
