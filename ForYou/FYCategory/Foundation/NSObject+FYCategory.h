//
//  NSObject+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (FYCategory)

/**
 *  是否为空对象
 *
 *  @return nil/NSNull NSString长度为0 NSArray/NSDictionary count 为0 返回为YES
 */
- (BOOL)isEmptyObject;

@end
