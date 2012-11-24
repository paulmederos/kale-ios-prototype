//
//  KAProfileViewController.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/23/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAProfileViewController : UIViewController <UIActionSheetDelegate>
{

    __weak IBOutlet UILabel *numberOfMeals;
    __weak IBOutlet UILabel *username;
}

@property (weak, nonatomic) IBOutlet UIImageView *profilePhoto;

- (IBAction)logout:(id)sender;

@end
