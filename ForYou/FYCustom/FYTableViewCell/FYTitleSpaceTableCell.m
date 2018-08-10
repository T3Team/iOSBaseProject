//
//  FYTitleSpaceTableCell.m
//  ForYou
//
//  Created by marcus on 2017/10/13.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYTitleSpaceTableCell.h"

@interface FYTitleSpaceTableCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *redViewWidthConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeftConstraint;

@end

@implementation FYTitleSpaceTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.titleLabel.text = self.cellModel.cellTitle;
    self.lineView.hidden = !self.cellModel.showLine;
    self.redViewWidthConstraint.constant = (self.cellModel.cellTag==1)?4:0;
    self.titleLeftConstraint.constant = (self.cellModel.cellTag==1)?10:0;
}

@end
