//
//  FYBlock.h
//  ForYou
//
//  Created by marcus on 2017/9/7.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYBaseModel.h"

#ifndef FYBlock_h
#define FYBlock_h

/**
 无参数 无返回值
 */
typedef void(^FYBlock)();

/**
 无参数 返回BOOL值

 @return BOOL类型的值
 */
typedef BOOL(^FYResultBlock)();

/**
 参数为BOOL类型 无返回值

 @param BOOL BOOL类型参数
 */
typedef void(^FYParameterBlock)(BOOL);

/**
 参数为int类型 无返回值
 
 @param int int类型参数
 */
typedef void(^FYParameterIntBlock)(NSInteger);

/**
 参数为NSDictionary类型 无返回值

 @param NSDictionary NSDictionary类型参数
 */
typedef void(^FYParameterDicBlock)(NSDictionary *);

/**
 参数为NSString类型 无返回值

 @param NSString NSString类型参数
 */
typedef void(^FYParameterStringBlock)(NSString *);

/**
 参数为NSIndexPath类型 无返回值
 
 @param NSIndexPath NSIndexPath类型参数
 */
typedef void(^FYParameterIndexPathBlock)(NSIndexPath *);

typedef void(^FYParameterModelBlock)(FYBaseModel *);


#endif /* FYBlock_h */
