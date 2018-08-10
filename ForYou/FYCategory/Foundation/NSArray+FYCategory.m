//
//  NSArray+FYCategory.m
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "NSArray+FYCategory.h"
#import "FYFoundationCategory.h"

@implementation NSArray (FYCategory)

- (NSArray *)arrayWithCleanNSNullValue
{
    NSMutableArray* newArr = [@[] mutableCopy];
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (![obj isKindOfClass:[NSNull class]])
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                [newArr addObject:[obj dictionaryWithCleanNSNullValue]];
            }
            else if ([obj isKindOfClass:[NSArray class]])
            {
                [newArr addObject:[obj arrayWithCleanNSNullValue]];
            }
            else if ([obj isKindOfClass:[NSSet class]])
            {
                [newArr addObject:[obj setWithCleanNSNullValue]];
            }
            else
            {
                [newArr addObject:obj];
            }
        }
    }];
    return [NSArray arrayWithArray:newArr];
}

@end
