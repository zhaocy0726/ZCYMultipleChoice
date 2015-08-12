//
//  SelectedPersonsCollectionCell.m
//  ZCYMultipleChoice
//
//  Created by zhaochunyang on 15/8/6.
//  Copyright (c) 2015年 zhaochunyang. All rights reserved.
//

#import "SelectedPersonsCollectionCell.h"

@interface SelectedPersonsCollectionCell ()

@property (nonatomic, assign) NSDictionary *dictionary;

@end

@implementation SelectedPersonsCollectionCell

//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // 初始化时加载collectionCell.xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"SelectedPersonsCollectionCell" owner:self options:nil];
        
        // 如果路径不存在，return nil
        if (arrayOfViews.count < 1)
        {
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]])
        {
            return nil;
        }
        // 加载nib
        self = [arrayOfViews objectAtIndex:0];
    }  
    return self;
}

- (void)configUserNameWithName:(NSDictionary *)dic
{
    _dictionary = [NSDictionary dictionary];
    _dictionary = dic;
    
    UIImage *image = _dictionary[@"image"];
    
    self.imageSelectedFriendAvatar.layer.cornerRadius = 18;
    self.imageSelectedFriendAvatar.image = image;
}

@end
