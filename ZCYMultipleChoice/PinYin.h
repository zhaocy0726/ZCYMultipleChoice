//
//  PinYin.h
//  ZCYMultipleChoice
//
//  Created by zhaochunyang on 15/8/7.
//  Copyright (c) 2015年 zhaochunyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PinYin : NSObject

/**
 *  @brief 拼音首字母
 *
 *  @param hanzi 汉字
 *
 *  @return 首字母
 */
char pinyinFirstLetter(unsigned short hanzi);

@end
