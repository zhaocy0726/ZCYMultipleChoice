//
//  PersonsListCell.h
//  ZCYMultipleChoice
//
//  Created by zhaochunyang on 15/8/5.
//  Copyright (c) 2015年 zhaochunyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonsListCell : UITableViewCell

@property (nonatomic, assign) BOOL isSelected;

@property (strong, nonatomic) IBOutlet UIImageView *imageSelected;
@property (strong, nonatomic) IBOutlet UIImageView *imageAvatar;
@property (strong, nonatomic) IBOutlet UILabel *labelFriendName;

- (void)configUserNameWithName:(NSDictionary *)dic;
- (void)configSelected:(BOOL)isSelected;

@end
