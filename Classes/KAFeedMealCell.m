//
//  KAFeedMealCell.m
//  kale
//
//  Created by Paul Mederos Jr on 12/9/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAFeedMealCell.h"
#import "UIImageView+AFNetworking.h"
#import <QuartzCore/QuartzCore.h>

@implementation KAFeedMealCell

@synthesize mealPhoto, mealTitle, mealDate, mealUser, mealUserPhoto, mealCommentCount, commentBubble, mealContainer;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareWithMeal:(KAMeal *)meal
{
    self.backgroundColor = [UIColor colorWithRed:245.0/255.0f green:239.0/255.0f blue:233.0/255.0f alpha:1.0];
    [mealTitle setLineBreakMode:NSLineBreakByWordWrapping];
    mealTitle.text = meal.title;
    mealDate.text = meal.eatenAt;
    mealUser.text = meal.ownerUsername;
    mealCommentCount.text = meal.commentCount;
    
    [mealPhoto setImageWithURL:[NSURL URLWithString:meal.photoSquareURL] placeholderImage:[UIImage imageNamed:@"meal_photo-placeholder"]];
    [mealUserPhoto setImageWithURL:[NSURL URLWithString:meal.ownerAvatarThumbURL] placeholderImage:nil];
    [commentBubble setImage:[UIImage imageNamed:@"table-comment-bubble.png"]];
    
    mealContainer.layer.borderColor = [UIColor colorWithRed:0.0/255.0f
                                                      green:0.0/255.0f
                                                       blue:0.0/255.0f
                                                      alpha:0.3].CGColor;
    mealContainer.layer.borderWidth = 1.0f;
    mealContainer.layer.backgroundColor = [UIColor whiteColor].CGColor;
    mealContainer.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
    mealContainer.layer.shadowColor = [UIColor grayColor].CGColor;
    mealContainer.layer.shadowOpacity = 0.3f;
    mealContainer.layer.cornerRadius = 3.0f;
    
    if (![meal.commentCount isEqualToString:@"0"]) {
        mealCommentCount.text = meal.commentCount;
    } else {
        mealCommentCount.text = nil;
        [commentBubble setImage:nil];
    }
    
    [self setNeedsDisplay];
}

@end
