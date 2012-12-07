//
//  KAProfileMealCell.m
//  Kale
//
//  Created by Paul Mederos Jr on 12/6/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAProfileMealCell.h"

@implementation KAProfileMealCell

@synthesize mealPhoto, mealTitle, mealDate;

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

@end
