//
//  FYBaseTableViewCell.m
//  ForYou
//
//  Created by marcus on 2017/8/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYBaseTableViewCell.h"

@implementation FYBaseTableViewCell

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel {
    self.cellModel = cellModel;
    self.dataModel = dataModel;
}

- (void)becomeFirstResponderWithTag:(NSString *)tag {
    
}

- (NSString *)checkMustInputBecomeFirstResponder:(BOOL)become {
    return nil;
}

@end
