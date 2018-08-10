//
//  FYSwitchTableCell.m
//  ForYou
//
//  Created by marcus on 2017/8/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYSwitchTableCell.h"

@interface FYSwitchTableCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchButton;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *mustInputMark;

@end

@implementation FYSwitchTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.lineView.hidden = !self.cellModel.showLine;
    self.mustInputMark.hidden = !self.cellModel.mustInput;
    self.titleLabel.text = self.cellModel.cellTitle;
    self.switchButton.on = [[self.dataModel valueForKey:self.cellModel.key] boolValue];
}

- (IBAction)valueChange:(UISwitch *)sender {
    if (self.cellModel.valueChangeBlock) {
       BOOL result = self.cellModel.valueChangeBlock();
       if (result && [self.cellModel.cellTitle isEqualToString:@"公盘"]) {
           BOOL temp = [[self.dataModel valueForKey:self.cellModel.key] integerValue] == 2;
           NSString *message = [NSString stringWithFormat:@"您是否确认修改为%@",temp?@"私盘":@"公盘"];
           UIViewController *viewController = [UIViewController currentViewController];
           [UIAlertController showColorAlertInViewController:viewController
                                                   withTitle:@""
                                                     message:message
                                             leftButtonTitle:@"是"
                                                leftBtnColor:color_red_ea4c40
                                            rightButtonTitle:@"否"
                                                  rightColor:color_blue_00a0e9
                                           otherButtonTitles:nil
                                                    tapBlock:^(UIAlertController * _Nonnull controller, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
                                                        if (buttonIndex == controller.cancelButtonIndex) {
                                                            [self.dataModel setObject:sender.on?@"2":@"1" forKey:self.cellModel.key];

                                                        } else if (buttonIndex == controller.destructiveButtonIndex) {
                                                            sender.on = !sender.on;
                                                        }
                                                    }];
       }
    }else {
        [self.dataModel setObject:[NSString stringWithFormat:@"%@",sender.on?@"2":@"1"] forKey:self.cellModel.key];
    }
}


@end
