//
//  FYHouseTypeTableCell.m
//  ForYou
//
//  Created by marcus on 2017/10/11.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYHouseTypeTableCell.h"

@interface FYHouseTypeTableCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *roomTextField;
@property (weak, nonatomic) IBOutlet UITextField *hallTextField;
@property (weak, nonatomic) IBOutlet UITextField *bathroomTextField;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *mustInputImageView;

@end

@implementation FYHouseTypeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.roomTextField.delegate = self;
    self.hallTextField.delegate = self;
    self.bathroomTextField.delegate = self;
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.roomTextField.enabled = self.cellModel.canEdit;
    self.hallTextField.enabled = self.cellModel.canEdit;
    self.bathroomTextField.enabled = self.cellModel.canEdit;
    self.roomTextField.textColor = self.cellModel.canEdit?color_black3:color_black9;
    self.hallTextField.textColor = self.cellModel.canEdit?color_black3:color_black9;
    self.bathroomTextField.textColor = self.cellModel.canEdit?color_black3:color_black9;
    self.line.hidden = !self.cellModel.showLine;
    self.mustInputImageView.hidden = !self.cellModel.mustInput;
    NSString *text = [self.dataModel valueForKey:self.cellModel.key];
    if (![NSString isEmpty:text]) {
        NSString *roomNo = @"0";
        NSString *hallNo = @"0";
        NSString *bathroomNo = @"0";
        NSArray *array = [text componentsSeparatedByString:@"-"];
        if (array) {
            if (array.count>0) {
                roomNo = array[0];
            }
            if (array.count>1) {
                hallNo = array[1];
            }
            if (array.count>2) {
                bathroomNo = array[2];
            }
        }
        self.roomTextField.text = roomNo;
        self.hallTextField.text = hallNo;
        self.bathroomTextField.text = bathroomNo;
    }else {
        self.roomTextField.text = @"";
        self.hallTextField.text = @"";
        self.bathroomTextField.text = @"";
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if ([textField.text isEqualToString:@"0"]) {
        textField.text = @"";
        NSString *room = self.roomTextField.text?:@"";
        NSString *hall = self.hallTextField.text?:@"";
        NSString * bathroom = self.bathroomTextField.text?:@"";
        if (textField == self.roomTextField) {
            room = @"";
        }
        if (textField == self.hallTextField) {
            hall = @"";
        }
        if (textField == self.bathroomTextField) {
            bathroom = @"";
        }
        [self.dataModel setValue:[NSString stringWithFormat:@"%@-%@-%@",room,hall,bathroom] forKey:self.cellModel.key];
        if (self.cellModel.valueChangeBlock) {
            self.cellModel.valueChangeBlock();
        }
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    
    result =  [NSString validateDecimalsNumber:string];
    
    NSString *text = textField.text;
    if (result) {
        if (range.length==0) {
            text = [text stringByAppendingString:string];
        }else {
            text = [text stringByReplacingCharactersInRange:range withString:string];
        }
    }
    
    if (result) {
        if (text.length > self.cellModel.lengthMax) {
            result = NO;
        }
        if (!result) {
            [FYProgressHUD topWindonsShowToastStatus:[NSString stringWithFormat:@"输入%@超出范围",self.cellModel.cellTitle]];
        }
    }
    
    if (self.cellModel && self.dataModel && result) {
        NSString *room = self.roomTextField.text?:@"";
        NSString *hall = self.hallTextField.text?:@"";
        NSString * bathroom = self.bathroomTextField.text?:@"";
        if (textField == self.roomTextField) {
            room = text;
        }
        if (textField == self.hallTextField) {
            hall = text;
        }
        if (textField == self.bathroomTextField) {
            bathroom = text;
        }
        [self.dataModel setValue:[NSString stringWithFormat:@"%@-%@-%@",room,hall,bathroom] forKey:self.cellModel.key];
        if (self.cellModel.valueChangeBlock) {
            self.cellModel.valueChangeBlock();
        }
    }
    return result;
}

- (NSString *)checkMustInputBecomeFirstResponder:(BOOL)become {
    NSString *result = nil;
    if (self.cellModel.mustInput) {
        if ([NSString isEmpty:self.roomTextField.text]) {
            result = [NSString stringWithFormat:@"请输入%@",self.cellModel.cellTitle];
            if (become) {
                [self.roomTextField becomeFirstResponder];
            }
            return result;
        }

        if ([NSString isEmpty:self.hallTextField.text]) {
            result = [NSString stringWithFormat:@"请输入%@",self.cellModel.cellTitle];
            if (become) {
                [self.hallTextField becomeFirstResponder];
            }
            return result;
        }

        if ([NSString isEmpty:self.bathroomTextField.text]) {
            result = [NSString stringWithFormat:@"请输入%@",self.cellModel.cellTitle];
            if (become) {
                [self.bathroomTextField becomeFirstResponder];
            }
            return result;
        }
    }
    return result;
}

@end
