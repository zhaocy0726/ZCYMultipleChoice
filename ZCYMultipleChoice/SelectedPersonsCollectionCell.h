//
//  SelectedPersonsCollectionCell.h
//  ZCYMultipleChoice
//
//  Created by zhaochunyang on 15/8/6.
//  Copyright (c) 2015年 zhaochunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedPersonsCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *imageSelectedFriendAvatar;

- (void)configUserNameWithName:(NSDictionary *)dic;

@end
