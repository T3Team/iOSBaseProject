//
//  FYInputRangeTableCell.h
//  ForYou
//
//  Created by marcus on 2017/9/20.
//  Copyright © 2017年 ForYou. All rights reserved.
//  范围输入框cell  

#import <UIKit/UIKit.h>
#import "FYBaseTableViewCell.h"

@interface FYInputRangeTableCell : FYBaseTableViewCell
@property (weak, nonatomic) IBOutlet UITextField *startTextField;
@property (weak, nonatomic) IBOutlet UITextField *endTextField;

@end
