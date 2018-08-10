//
//  FYTitleHeaderReusableView.m
//  ForYou
//
//  Created by marcus on 2018/5/21.
//  Copyright © 2018年 ForYou. All rights reserved.
//

#import "FYTitleHeaderReusableView.h"

@interface FYTitleHeaderReusableView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FYTitleHeaderReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshTitle:(NSString *)title {
    self.titleLabel.text = title;
}

@end
