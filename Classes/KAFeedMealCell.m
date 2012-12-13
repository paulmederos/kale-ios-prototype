//
//  KAFeedMealCell.m
//  kale
//
//  Created by Paul Mederos Jr on 12/9/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAFeedMealCell.h"
#import "UIImageView+AFNetworking.h"

@implementation KAFeedMealCell

@synthesize mealPhoto, mealTitle, mealDate, mealUser, mealUserPhoto;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
           withMeal:(KAMeal *)meal
{
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        mealTitle.text = meal.title;
        mealDate.text = meal.eatenAt;
        mealUser.text = meal.ownerUsername;
        [mealPhoto setImageWithURL:[NSURL URLWithString:meal.photoSquareURL] placeholderImage:nil];
        [mealUserPhoto setImageWithURL:[NSURL URLWithString:meal.ownerAvatarThumbURL] placeholderImage:nil];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
