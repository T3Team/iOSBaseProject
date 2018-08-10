//
//  FYImageCollectionViewCell.m
//  ForYou
//
//  Created by marcus on 2018/5/18.
//  Copyright © 2018年 ForYou. All rights reserved.
//

#import "FYImageCollectionViewCell.h"
#import "FYHeader.h"
@interface FYImageCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation FYImageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)refreshWithImageUrl:(NSString *)imageUrl {
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:nil];
}

@end
