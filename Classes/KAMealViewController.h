//
//  KAMealViewController.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAMeal.h"

@interface KAMealViewController : UIViewController
{
    __weak IBOutlet UILabel *titleLabel;
    __weak IBOutlet UILabel *usernameLabel;
    __weak IBOutlet UIImageView *userAvatar;
    __weak IBOutlet UIImageView *photo;

}

@property(strong, nonatomic) KAMeal *meal;

@end
