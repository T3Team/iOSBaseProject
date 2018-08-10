//
//  NSSet+FYCategory.m
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "NSSet+FYCategory.h"
#import "FYFoundationCategory.h"

@implementation NSSet (FYCategory)

- (NSSet *)setWithCleanNSNullValue
{
    NSMutableSet* newSet = [NSMutableSet set];
    [self enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if (![obj isKindOfClass:[NSNull class]])
        {
            if ([obj isKindOfClass:[NSDictionary class]])
            {
                [newSet addObject:[obj dictionaryWithCleanNSNullValue]];
            }
            else if ([obj isKindOfClass:[NSArray class]])
            {
                [newSet addObject:[obj arrayWithCleanNSNullValue]];
            }
            else if ([obj isKindOfClass:[NSArray class]])
            {
                [newSet addObject:[obj setWithCleanNSNullValue]];
            }
            else
            {
                [newSet addObject:obj];
            }
        }
    }];
    return newSet;
}

@end
