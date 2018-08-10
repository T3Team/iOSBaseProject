//
//  FYEditSelectedStateCell.m
//  ForYou
//
//  Created by marcus on 2018/5/16.
//  Copyright © 2018年 ForYou. All rights reserved.
//

#import "FYEditSelectedStateCell.h"

@interface FYEditSelectedStateCell() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UIButton *selectedButton;
@property (weak, nonatomic) IBOutlet UIView *line;
@end

@implementation FYEditSelectedStateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputTextField.delegate = self;
    self.inputTextField.returnKeyType = UIReturnKeyDone;
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.titleLabel.text = self.cellModel.cellTitle;
    self.inputTextField.placeholder = self.cellModel.placeholder;
    self.inputTextField.text = [self.dataModel valueForKey:self.cellModel.key]?:@"";
    NSString *selectedKey = [NSString stringWithFormat:@"%@Selected",self.cellModel.key];
    [self.selectedButton setImage:[[self.dataModel valueForKey:selectedKey]?:@"0" isEqualToString:@"1"]?icon_circleSelected_selected:icon_circleSelected_normal forState:UIControlStateNormal];
    self.line.hidden = !self.cellModel.showLine;
}

- (IBAction)clickSelectedButton:(UIButton *)sender {
    NSString *selectedKey = [NSString stringWithFormat:@"%@Selected",self.cellModel.key];
    BOOL bSelected = [[self.dataModel valueForKey:selectedKey]?:@"0" isEqualToString:@"1"];
    bSelected = !bSelected;
    [self.dataModel setObject:bSelected?@"1":@"0" forKey:selectedKey];
    [self.selectedButton setImage:[[self.dataModel valueForKey:selectedKey]?:@"0" isEqualToString:@"1"]?icon_circleSelected_selected:icon_circleSelected_normal forState:UIControlStateNormal];
    if (bSelected) {
        [self.inputTextField becomeFirstResponder];
    }else {
        [self.inputTextField resignFirstResponder];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    
    NSString *text = self.inputTextField.text;
    if (result) {
        if (range.length==0) {
            text = [text stringByAppendingString:string];
        }else {
            text = [text stringByReplacingCharactersInRange:range withString:string];
        }
    }
    
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!(range.length==0 && position)) {  //当前正在高亮时不需要校验长度 并且不会实时更新数据
        if (!([NSString isEmpty:string] && range.length!=0)) { //正在删除时也不需要校验长度
            if ((text.length > self.cellModel.lengthMax) && (self.cellModel.lengthMax!=0)) {
                result = NO;
            }
            if (!result) {
                [FYProgressHUD topWindonsShowToastStatus:[NSString stringWithFormat:@"输入%@超出范围",self.cellModel.cellTitle]];
                
                //此时需要更新下model中的数据
                NSString *textOld = self.inputTextField.text;
                if (range.length==0) {
                    textOld = [textOld stringByAppendingString:@""];
                }else {
                    textOld = [textOld stringByReplacingCharactersInRange:range withString:@""];
                }
                
                if (self.cellModel && self.dataModel) {
                    [self.dataModel setValue:textOld forKey:self.cellModel.key];
                    if (self.cellModel.valueChangeBlock) {
                        self.cellModel.valueChangeBlock();
                    }
                }
            }
        }
        
        if (self.cellModel && self.dataModel && result) {
            [self.dataModel setValue:text forKey:self.cellModel.key];
            if (self.cellModel.valueChangeBlock) {
                self.cellModel.valueChangeBlock();
            }
        }
    }
    
    return result;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    NSString *selectedKey = [NSString stringWithFormat:@"%@Selected",self.cellModel.key];
    BOOL bSelected = [[self.dataModel valueForKey:selectedKey]?:@"0" isEqualToString:@"1"];
    if (!bSelected) {  //非勾选状态是勾选
        [self clickSelectedButton:self.selectedButton];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([NSString isEmpty:textField.text]) {
        NSString *selectedKey = [NSString stringWithFormat:@"%@Selected",self.cellModel.key];
        BOOL bSelected = [[self.dataModel valueForKey:selectedKey]?:@"0" isEqualToString:@"1"];
        if (bSelected) {  //非勾选状态是勾选
            [self clickSelectedButton:self.selectedButton];
        }
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self endEditing:YES];
    return YES;
}

@end
