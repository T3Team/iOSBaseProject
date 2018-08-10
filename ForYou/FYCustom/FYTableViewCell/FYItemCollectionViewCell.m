//
//  FYItemCollectionViewCell.m
//  ForYou
//
//  Created by marcus on 2017/11/30.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYItemCollectionViewCell.h"
#import "FYHeader.h"

@interface FYItemCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *bottomLine;
@property (weak, nonatomic) IBOutlet UIView *rightLine;

@end



@implementation FYItemCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshWithTitle:(NSString *)title image:(UIImage *)image hideRightLine:(BOOL)hideRightLine hideBottomLine:(BOOL)hideBottomLine {
    if (![NSString isEmpty:title]) {
        self.titleLabel.hidden = NO;
        self.imageView.hidden = YES;
        self.titleLabel.text = title;
    }else if (image) {
        self.titleLabel.hidden = YES;
        self.imageView.hidden = NO;
        self.imageView.image = image;
    }
    self.rightLine.hidden = hideRightLine;
    self.bottomLine.hidden = hideBottomLine;
}

@end
