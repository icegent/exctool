//
//  TMPJCollectionFooterView.h
//  objctemplate
//
//  Created by supertext on 15/3/11.
//  Copyright (c) 2015年 icegent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMPJImageView;
@class TMPJLabel;
@interface TMPJCollectionViewSectionFooter : UICollectionReusableView
@property(nonatomic,strong,readonly)TMPJImageView *imageView;
@property(nonatomic,strong,readonly)TMPJLabel *textLabel;
@end
