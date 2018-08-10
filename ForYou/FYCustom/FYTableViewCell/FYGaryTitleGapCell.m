//
//  FYGaryTitleGapCell.m
//  ForYou
//
//  Created by marcus on 2018/5/17.
//  Copyright © 2018年 ForYou. All rights reserved.
//

#import "FYGaryTitleGapCell.h"

@interface FYGaryTitleGapCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation FYGaryTitleGapCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.titleLabel.text = self.cellModel.cellTitle;
}

@end
