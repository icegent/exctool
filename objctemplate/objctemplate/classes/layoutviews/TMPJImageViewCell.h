//
//  TMPJImageViewCell.h
//  objctemplate
//
//  Created by supertext on 15/3/11.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import "TMPJTableViewCell.h"
@class TMPJImageView;
@interface TMPJImageViewCell : TMPJTableViewCell
@property(nonatomic,strong,readonly)TMPJImageView *iconView;
@end
