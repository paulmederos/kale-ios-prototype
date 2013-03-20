//
//  KAProfileViewController.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "KAUser.h"
#import "SSPullToRefresh.h"
#import "UIImageView+LBBlurredImage.h"


@interface KAProfileViewController : UIViewController <SSPullToRefreshViewDelegate, UIActionSheetDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate>
{

}

@property (strong, nonatomic) KAUser *user;
@property (strong, nonatomic) NSArray *userMeals;
@property (weak, nonatomic) IBOutlet UICollectionView *mealsCollection;


@end
