//
//  KAMealViewController.h
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "KAMeal.h"
#import "KAMealCommentCell.h"
#import <SSToolkit/SSTextField.h>

@interface KAMealViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate, UIScrollViewDelegate>
{

}

@property (strong, nonatomic) IBOutlet UITableView *commentsTable;
@property (retain, nonatomic) NSArray *comments;
@property (strong, nonatomic) KAMeal *meal;

@property (strong, nonatomic) IBOutlet UIImageView *mealPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *mealUserPhoto;
@property (strong, nonatomic) IBOutlet UILabel *mealUser;
@property (strong, nonatomic) IBOutlet UILabel *mealDate;
@property (strong, nonatomic) IBOutlet UILabel *mealTitle;

@property (strong, nonatomic) IBOutlet UIToolbar *commentToolbar;
@property (strong, nonatomic) IBOutlet SSTextField *commentField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *sendCommentButton;


- (IBAction)postComment:(id)sender;


@end
