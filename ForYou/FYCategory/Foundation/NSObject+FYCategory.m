//
//  NSObject+FYCategory.m
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "NSObject+FYCategory.h"

@implementation NSObject (FYCategory)

- (BOOL)isEmptyObject
{
    
    if (!self) {
        return YES;
    }
    
    if (self == nil) {
        return YES;
    }
    
    if ([self isEqual:nil]) {
        return YES;
    }
    
    if ([self isEqual:[NSNull null]]) {
        return YES;
    }
    
    if ([self isKindOfClass:[NSString class]]) {
        if ([(NSString *)self length] == 0) {
            return YES;
        }
        if ([(NSString *)self isEqualToString:@""]) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSArray class]]) {
        if ([(NSArray *)self count] == 0) {
            return YES;
        }
    }
    
    if ([self isKindOfClass:[NSDictionary class]]) {
        if ([(NSDictionary *)self count] == 0) {
            return YES;
        }
    }
    
    return NO;
}

@end
