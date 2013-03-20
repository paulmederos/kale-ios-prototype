//
//  KAProfileCollectionHeaderView.m
//  Kale
//
//  Created by Paul Mederos on 3/19/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KAProfileCollectionHeaderView.h"

@implementation KAProfileCollectionHeaderView

@synthesize mealsCount, followersCount, followingCount, profilePhoto, profileUsername, pageScrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)customizeAppearance
{
    // Reset placeholders to nil
    profileUsername.text = nil;
    mealsCount.text = nil;
    followingCount.text = nil;
    followersCount.text = nil;
    
    // Bring profile photo to front of the profile pic
    [profilePhoto.layer setMasksToBounds:YES];
    [profilePhoto.layer setCornerRadius:8.0f];
    [profilePhoto.layer setBorderColor:[UIColor blackColor].CGColor];
    [profilePhoto.layer setBorderWidth:1.0f];
    [profilePhoto.layer setShadowColor:[UIColor whiteColor].CGColor];
    [profilePhoto.layer setShadowOffset:CGSizeMake(0,0)];
    [profilePhoto.layer setShadowOpacity:1];
    [profilePhoto.layer setShadowRadius:2.0];
    
    // Set placeholders while content loads
    [profilePhoto setImage:[UIImage imageNamed:@"meal_photo-placeholder.png"]];
}


@end
