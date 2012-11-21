//
//  KAMainNavigationBar.m
//  Kale
//
//  Created by Paul Mederos Jr on 11/20/12.
//  Copyright (c) 2012 Enchant. All rights reserved.
//

#import "KAMainNavigationBar.h"

@implementation KAMainNavigationBar

+ (void)initialize
{
    const CGFloat ArrowLeftCap = 14.0f;
    UIImage *back = [UIImage imageNamed:@"nav-backbutton.png"];
    back = [back stretchableImageWithLeftCapWidth:ArrowLeftCap
                                     topCapHeight:0];
    [[UIBarButtonItem appearanceWhenContainedIn:[KAMainNavigationBar class], nil]
     setBackButtonBackgroundImage:back                                                      forState:UIControlStateNormal                                                    barMetrics:UIBarMetricsDefault];
    
    const CGFloat BackButtonTextOffset = 3.0f;
    [[UIBarButtonItem appearanceWhenContainedIn:[KAMainNavigationBar class], nil]
     setBackButtonTitlePositionAdjustment:UIOffsetMake(BackButtonTextOffset, 0)
     forBarMetrics:UIBarMetricsDefault];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self customize];
    }
    return self;
}

- (void)customize
{
    UIImage *navBarBg = [UIImage imageNamed:@"navigationbar.png"];
    [self setBackgroundImage:navBarBg forBarMetrics:UIBarMetricsDefault];
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
