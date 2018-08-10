//
//  FYAddButtonTableCell.m
//  ForYou
//
//  Created by marcus on 2017/8/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYAddButtonTableCell.h"
#import "FYHeader.h"

@interface FYAddButtonTableCell()
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FYAddButtonTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.bottomView.layer setCornerRadius:20];
    [self.bottomView.layer setBorderWidth:1.0];
    [self.bottomView.layer setBorderColor:color_red_ea4c40.CGColor];
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.titleLabel.text = cellModel.cellTitle;
}


@end
