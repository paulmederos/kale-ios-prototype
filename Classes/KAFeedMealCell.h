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

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           withMeal:(KAMeal *)meal;

@property (strong, nonatomic) IBOutlet UIImageView *mealPhoto;
@property (strong, nonatomic) IBOutlet UILabel *mealTitle;
@property (strong, nonatomic) IBOutlet UILabel *mealDate;
@property (strong, nonatomic) IBOutlet UILabel *mealUser;
@property (strong, nonatomic) IBOutlet UIImageView *mealUserPhoto;

@end
