//
//  FYRangeInputCollectionCell.h
//  ForYou
//
//  Created by marcus on 2017/9/25.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYTableViewCellModel.h"

@interface FYRangeInputCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextField *minTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxTextField;

@property (nonatomic, copy) FYModelValueChangeBlock valueChangeBlock;

- (void)refreshView;

@end
