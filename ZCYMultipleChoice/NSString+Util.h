//
//  NSString+Util.h
//  ZCYMultipleChoice
//
//  Created by zhaochunyang on 15/8/7.
//  Copyright (c) 2015年 zhaochunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Util)

/**
 *  @brief 中文字符串的首字母
 *
 *  @param aString 字文字符串
 *
 *  @return 首字母
 */
+ (NSString *) firstLetter:(NSString*)aString;

/**
 *  @brief 所有索引字符串
 *
 *  @return 索引字符串
 */
+ (NSArray*)indexLetters;

/**
 *  判断是否为空
 *
 *  @param aString 传进的字符串
 *
 *  @return 是否为空
 */
+ (BOOL)isEmpty:(NSString *)aString;

/**
 *  @brief 去前后空格
 *
 *  @return 去空格后的值
 */
- (NSString *)trim;

@end
