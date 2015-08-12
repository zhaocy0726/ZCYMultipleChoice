//
//  NSString+Util.m
//  ZCYMultipleChoice
//
//  Created by zhaochunyang on 15/8/7.
//  Copyright (c) 2015年 zhaochunyang. All rights reserved.
//

#import "NSString+Util.h"
#import "PinYin.h"

@implementation NSString(Util)

+ (BOOL)isEmpty:(NSString*)aString{
    BOOL ret = NO;
    if ((aString==nil)|| ([[aString trim] length]==0) || [aString isKindOfClass:[NSNull class]])
        ret = YES;
    return ret;
}

+ (NSString *) firstLetter:(NSString*)aString
{
    NSString *firstLetter = @"#";
    if (![NSString isEmpty:aString]) {
        char firstLetterChar = pinyinFirstLetter([aString characterAtIndex:0]);
        if (firstLetterChar >='a' && firstLetterChar <= 'z') {
            firstLetterChar = firstLetterChar - 32;
        }
        if (firstLetterChar>='A' && firstLetterChar <='Z') {
            firstLetter = [NSString stringWithFormat:@"%c",firstLetterChar];
        }
    }
    return firstLetter;
}

+ (NSArray*)indexLetters
{
    static NSMutableArray *indexTitleArray = nil;
    if (!indexTitleArray)
    {
        indexTitleArray = [[NSMutableArray alloc] init];
        //        [indexTitleArray addObject:UITableViewIndexSearch];
        for (char c='A'; c<='Z'; c++) {
            [indexTitleArray addObject:[NSString stringWithFormat:@"%c",c]];
        }
        [indexTitleArray addObject:@"#"];
    }
    return indexTitleArray;
}

// 去掉空格
- (NSString *)trim
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
