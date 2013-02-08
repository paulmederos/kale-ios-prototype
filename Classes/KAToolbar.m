//
//  KAToolbar.m
//  Kale
//
//  Created by Paul Mederos on 2/7/13.
//  Copyright (c) 2013 Enchant. All rights reserved.
//

#import "KAToolbar.h"

@implementation KAToolbar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self customize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self customize];
    }
    return self;
}

- (void)customize
{
    UIImage *button = [UIImage imageNamed:@"nav-button.png"];

    [[UIBarButtonItem appearanceWhenContainedIn:[KAToolbar class], nil] setBackgroundImage:button forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIImage *toolBarBackground = [UIImage imageNamed:@"navigationbar.png"];
    [self setBackgroundImage:toolBarBackground forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
