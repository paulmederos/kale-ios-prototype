//
//  KAProfileViewController.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface KAProfileViewController : UIViewController <UIActionSheetDelegate, UITableViewDataSource, UITableViewDelegate>
{

    __weak IBOutlet UILabel *numberOfMeals;
    __weak IBOutlet UILabel *username;
}

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;
@property (strong, nonatomic) NSArray *userMeals;
@property (strong, nonatomic) IBOutlet UITableView *mealsTable;

- (IBAction)logout:(id)sender;

@end
