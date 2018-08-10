//
//  FYRemarkTableCell.h
//  ForYou
//
//  Created by marcus on 2017/8/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//  备注cell 

#import <UIKit/UIKit.h>
#import "FYBaseTableViewCell.h"

@interface FYRemarkTableCell : FYBaseTableViewCell

- (NSString *)inputContent;

@property (nonatomic, copy) FYParameterStringBlock valueChangeBlock;
@end
