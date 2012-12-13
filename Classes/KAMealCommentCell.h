//
//  KAMealCommentCell.h
//  kale
//
//  Created by Paul Mederos Jr on 12/9/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KAMealCommentCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *commentOwnerAvatar;
@property (strong, nonatomic) IBOutlet UILabel *commentOwner;
@property (strong, nonatomic) IBOutlet UILabel *commentContent;
@property (strong, nonatomic) IBOutlet UILabel *commentDate;

@end
