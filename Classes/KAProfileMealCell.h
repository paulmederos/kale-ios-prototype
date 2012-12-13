//
//  KAProfileMealCell.h
//  Kale
//
//  Created by Paul Mederos Jr on 12/6/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAProfileMealCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *mealPhoto;
@property (strong, nonatomic) IBOutlet UILabel *mealTitle;
@property (strong, nonatomic) IBOutlet UILabel *mealDay;
@property (strong, nonatomic) IBOutlet UILabel *mealMonth;
@property (strong, nonatomic) IBOutlet UILabel *mealYear;

@end
