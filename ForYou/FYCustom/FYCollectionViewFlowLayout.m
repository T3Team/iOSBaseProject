//
//  FYCollectionViewFlowLayout.m
//  ForYou
//
//  Created by marcus on 2017/9/28.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYCollectionViewFlowLayout.h"

#define kItemSpacing 8.0
#define kItemHeight 31.0
#define kLineSpacing 8.0
#define kEdgeSpacing 16.0

@implementation FYCollectionViewFlowLayout

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    for(int i = 0; i < [answer count]; ++i) {
        UICollectionViewLayoutAttributes *currentLayoutAttributes = answer[i];
        if (currentLayoutAttributes.representedElementCategory == UICollectionElementCategoryCell) {  //为Cell
            if (currentLayoutAttributes.indexPath.row != 0) {  //每个分区的非第一个item
                UICollectionViewLayoutAttributes *prevLayoutAttributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:currentLayoutAttributes.indexPath.row-1 inSection:currentLayoutAttributes.indexPath.section]];
                NSInteger maximumSpacing = kItemSpacing;
                NSInteger origin = CGRectGetMaxX(prevLayoutAttributes.frame);
                if((origin + maximumSpacing + currentLayoutAttributes.frame.size.width <= self.collectionViewContentSize.width-kEdgeSpacing)&&(prevLayoutAttributes.frame.origin.y == currentLayoutAttributes.frame.origin.y)) { //同一行时，调整位置
                    CGRect frame = currentLayoutAttributes.frame;
                    frame.origin.x = origin + maximumSpacing;
                    currentLayoutAttributes.frame = frame;
                }else{                                    //重新换行后
                    CGRect frame = currentLayoutAttributes.frame;
                    frame.origin.x = kEdgeSpacing;
                    currentLayoutAttributes.frame = frame;
                }
            }else if (currentLayoutAttributes.indexPath.row == 0){  //每个分区的第一个item
                CGRect frame = currentLayoutAttributes.frame;
                frame.origin.x = kEdgeSpacing;
                currentLayoutAttributes.frame = frame;
            }
        }
    }
    return answer;
}

@end
