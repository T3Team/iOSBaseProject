//
//  FYItemCollectionViewCell.h
//  ForYou
//
//  Created by marcus on 2017/11/30.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYItemCollectionViewCell : UICollectionViewCell

- (void)refreshWithTitle:(NSString *)title image:(UIImage *)image hideRightLine:(BOOL)hideRightLine hideBottomLine:(BOOL)hideBottomLine;

@end
