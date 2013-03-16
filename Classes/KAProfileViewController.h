//
//  KAProfileViewController.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SSPullToRefresh.h"
#import "UIImageView+LBBlurredImage.h"


@interface KAProfileViewController : UIViewController <SSPullToRefreshViewDelegate, UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate>
{

    __weak IBOutlet UILabel *numberOfMeals;
    __weak IBOutlet UILabel *username;
    __weak IBOutlet UIView *profileContainer;
}

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (strong, nonatomic) NSArray *userMeals;
@property (strong, nonatomic) IBOutlet UITableView *mealsTable;
@property (weak, nonatomic) IBOutlet UIImageView *lastMealPhoto;

@end
