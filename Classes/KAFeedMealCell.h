//
//  KAFeedMealCell.h
//  kale
//
//  Created by Paul Mederos Jr on 12/9/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAMeal.h"

@interface KAFeedMealCell : UITableViewCell
{
    
}

@property (weak, nonatomic) IBOutlet UIView *mealContainer;
@property (strong, nonatomic) IBOutlet UIImageView *mealPhoto;
@property (strong, nonatomic) IBOutlet UILabel *mealTitle;
@property (strong, nonatomic) IBOutlet UILabel *mealDate;
@property (strong, nonatomic) IBOutlet UILabel *mealUser;
@property (strong, nonatomic) IBOutlet UILabel *mealCommentCount;
@property (strong, nonatomic) IBOutlet UIImageView *mealUserPhoto;
@property (strong, nonatomic) IBOutlet UIImageView *commentBubble;


- (void)prepareWithMeal:(KAMeal *)meal;

@end
