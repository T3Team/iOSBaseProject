//
//  FYSelectListCell.h
//  ForYou
//
//  Created by marcus on 2017/8/10.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYSelectListCell : UITableViewCell

@property (nonatomic ,copy) NSString *contentStr;

@property (nonatomic ,assign) BOOL isSelectOption;
@end
