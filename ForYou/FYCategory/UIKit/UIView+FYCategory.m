//
//  UIView+FYCategory.m
//  ForYou
//
//  Created by marcus on 2017/8/9.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "UIView+FYCategory.h"
#import "FYColors.h"

@implementation UIView (FYCategory)

+ (UIView *)fy_seprateLine{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    UIView *seprateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, .5)];
    seprateLine.backgroundColor = color_line;
    return seprateLine;
}

+ (UIImage *)convertView:(UIView *)view {
//    UIGraphicsBeginImageContext(view.bounds.size);
//    if([[UIScreen mainScreen] scale] == 3.0){
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 3.0);
//    }else if ([[UIScreen mainScreen] scale] == 2.0){
//        UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 2.0);
//    }else{
//        UIGraphicsBeginImageContext(view.bounds.size);
//    }
    
     UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, 3.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:ctx];
    UIImage* tImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return tImage;
//    [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:YES];
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return image;
}

- (CGFloat)fy_height
{
    return self.frame.size.height;
}

- (void)setFy_height:(CGFloat)fy_height
{
    CGRect temp = self.frame;
    temp.size.height = fy_height;
    self.frame = temp;
}

- (CGFloat)fy_width
{
    return self.frame.size.width;
}

- (void)setFy_width:(CGFloat)fy_width
{
    CGRect temp = self.frame;
    temp.size.width = fy_width;
    self.frame = temp;
}


- (CGFloat)fy_y
{
    return self.frame.origin.y;
}

- (void)setFy_y:(CGFloat)fy_y
{
    CGRect temp = self.frame;
    temp.origin.y = fy_y;
    self.frame = temp;
}

- (CGFloat)fy_x
{
    return self.frame.origin.x;
}

- (void)setFy_x:(CGFloat)fy_x
{
    CGRect temp = self.frame;
    temp.origin.x = fy_x;
    self.frame = temp;
}

@end
