//
//  PersonsListCell.m
//  ZCYMultipleChoice
//
//  Created by zhaochunyang on 15/8/5.
//  Copyright (c) 2015年 zhaochunyang. All rights reserved.
//

#import "PersonsListCell.h"

@interface PersonsListCell ()

@property (nonatomic, assign) NSDictionary *dictionary;
@end

@implementation PersonsListCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    _imageAvatar.layer.cornerRadius = 20.f;
}

//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//    
//    if (self.isSelected)
//        self.imageSelected.image = [UIImage imageNamed:@"selected"];
//    else
//        self.imageSelected.image = [UIImage imageNamed:@"unSelected"];
//}

- (void)configUserNameWithName:(NSDictionary *)dic
{
    _dictionary = [NSDictionary dictionary];
    _dictionary = dic;
    
    UIImage *image = _dictionary[@"image"];
    NSString *name = _dictionary[@"name"];
    
    self.imageAvatar.image = image;
    self.labelFriendName.text = name;
    
    // 解决重用问题
    [self configSelected:self.isSelected];
}

- (void)configSelected:(BOOL)isSelected
{
    self.isSelected = isSelected;
    if (isSelected) {
        self.imageSelected.image = [UIImage imageNamed:@"selected"];
    }
    else {
        self.imageSelected.image = [UIImage imageNamed:@"unSelected"];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
