//
//  KAProfileCollectionHeaderView.h
//  Kale
//
//  Created by Paul Mederos on 3/19/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAProfileCollectionHeaderView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (weak, nonatomic) IBOutlet UILabel *profileUsername;
@property (weak, nonatomic) IBOutlet UILabel *mealsCount;
@property (weak, nonatomic) IBOutlet UILabel *followingCount;
@property (weak, nonatomic) IBOutlet UILabel *followersCount;

@property (weak, nonatomic) IBOutlet UIScrollView *pageScrollView;


@end
